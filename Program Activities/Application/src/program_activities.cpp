// Use kanzi.hpp only when you are learning to develop Kanzi applications.
// To improve compilation time in production projects, include only the header files of the Kanzi functionality you are using.
#include <kanzi/kanzi.hpp>

#if defined(PROGRAM_ACTIVITIES_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_API_IMPORT)
#include <Program_Activities_code_behind_module.hpp>
#endif

using namespace kanzi;

class ProgramActivities : public ExampleApplication
{
public:

    void onConfigure(ApplicationProperties& configuration) override
    {
        configuration.binaryName = "program_activities.kzb.cfg";
    }

    void onProjectLoaded() override
    {
        // Project file has been loaded from .kzb file.

        // Add initialization code here.
    }

    void registerMetadataOverride(ObjectFactory& factory) override
    {
        ExampleApplication::registerMetadataOverride(factory);

#if defined(PROGRAM_ACTIVITIES_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_API_IMPORT)
        ProgramActivitiesCodeBehindModule::registerModule(getDomain());
#endif
    }
};

Application* createApplication()
{
    return new ProgramActivities;
}
