#include <kanzi/kanzi.hpp>

// [CodeBehind libs inclusion]. Do not remove this identifier.

#if defined(STATS_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_API_IMPORT)
# include <stats_code_behind_module.hpp>
#endif

#if defined(RESOURCES_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_API_IMPORT)
# include <resources_code_behind_module.hpp>
#endif

#if defined(CENTER_STACK_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
#include <center_stack_code_behind_module.hpp>
#endif

using namespace kanzi;

class CenterStack : public ExampleApplication
{
public:

    void onConfigure(ApplicationProperties& configuration) override
    {
        configuration.binaryName = "center_stack.kzb.cfg";
    }

    void onProjectLoaded() override
    {
        // Project file has been loaded from .kzb file.

        // Add initialization code here.
    }

    void registerMetadataOverride(ObjectFactory& factory) override
    {
        ExampleApplication::registerMetadataOverride(factory);

#if defined(CENTER_STACK_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
        CenterStackCodeBehindModule::registerModule(getDomain());
#endif

        // [CodeBehind module inclusion]. Do not remove this identifier.

#if defined(STATS_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_API_IMPORT)
        StatsCodeBehindModule::registerModule(getDomain());
#endif

#if defined(RESOURCES_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_API_IMPORT)
        ResourcesCodeBehindModule::registerModule(getDomain());
#endif
    }
};

Application* createApplication()
{
    return new CenterStack;
}
