// Use kanzi.hpp only when you are learning to develop Kanzi applications.
// To improve compilation time in production projects, include only the header files of the Kanzi functionality you are using.
#include <kanzi/kanzi.hpp>

#if !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
#include <xmldatasource_module.hpp>
#endif

// [CodeBehind libs inclusion]. Do not remove this identifier.

#if defined(STENCIL_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
#include <stencil_code_behind_module.hpp>
#endif

using namespace kanzi;

class Stencil : public ExampleApplication
{
public:

    void onConfigure(ApplicationProperties& configuration) override
    {
        configuration.binaryName = "stencil.kzb.cfg";
    }

    void onProjectLoaded() override
    {
        // Project file has been loaded from .kzb file.

        // Add initialization code here.
    }

    void registerMetadataOverride(ObjectFactory& factory) override
    {
        ExampleApplication::registerMetadataOverride(factory);

#if !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
        XMLDataSourceModule::registerModule(getDomain());
#endif

#if defined(STENCIL_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
        StencilCodeBehindModule::registerModule(getDomain());
#endif

        // [CodeBehind module inclusion]. Do not remove this identifier.
    }
};

Application* createApplication()
{
    return new Stencil;
}