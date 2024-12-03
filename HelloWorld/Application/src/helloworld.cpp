// Use kanzi.hpp only when you are learning to develop Kanzi applications.
// To improve compilation time in production projects, include only the header files of the Kanzi functionality you are using.
#include <kanzi/kanzi.hpp>
#include <kanzi/core/log/log.hpp>

// [CodeBehind libs inclusion]. Do not remove this identifier.

#if defined(HELLOWORLD_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
#include <HelloWorld_code_behind_module.hpp>
#endif

using namespace kanzi;

class HelloWorld : public ExampleApplication
{
public:

    void onConfigure(ApplicationProperties& configuration) override
    {
        configuration.binaryName = "helloworld.kzb.cfg";
    }

    void onProjectLoaded() override
    {
        // Project file has been loaded from .kzb file.

        // Add initialization code here.
        kzLogInfo(KZ_LOG_CATEGORY_GENERIC, ("Hello World!"));

        ScreenSharedPtr screenNodePtr = getScreen();
        TextBlock2DSharedPtr textNodePtr = screenNodePtr->lookupNode<TextBlock2D>("#Text Block 2D");
        if (textNodePtr)
        {
            textNodePtr->setText("Hello World!");
        }
    }

    void registerMetadataOverride(ObjectFactory& factory) override
    {
        ExampleApplication::registerMetadataOverride(factory);

#if defined(HELLOWORLD_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
        HelloWorldCodeBehindModule::registerModule(getDomain());
#endif

        // [CodeBehind module inclusion]. Do not remove this identifier.
    }
};

Application* createApplication()
{
    return new HelloWorld;
}
