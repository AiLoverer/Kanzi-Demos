// Use kanzi.hpp only when you are learning to develop Kanzi applications.
// To improve compilation time in production projects, include only the header files of the Kanzi functionality you are using.
#include <kanzi/kanzi.hpp>

// [CodeBehind libs inclusion]. Do not remove this identifier.

#if defined(DATADRIVEN_ACTIVITIES_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_API_IMPORT)
#include <DataDriven_Activities_code_behind_module.hpp>
#endif

using namespace kanzi;

class DataDrivenActivities : public ExampleApplication
{
public:

    void onConfigure(ApplicationProperties& configuration) override
    {
        configuration.binaryName = "data-driven_activities.kzb.cfg";
    }

    void onProjectLoaded() override
    {
        // Project file has been loaded from .kzb file.

        // Add initialization code here.
    }

    void registerMetadataOverride(ObjectFactory& factory) override
    {
        ExampleApplication::registerMetadataOverride(factory);

#if defined(DATADRIVEN_ACTIVITIES_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_API_IMPORT)
        DataDrivenActivitiesCodeBehindModule::registerModule(getDomain());
#endif

        // [CodeBehind module inclusion]. Do not remove this identifier.
    }
};

Application* createApplication()
{
    return new DataDrivenActivities;
}
