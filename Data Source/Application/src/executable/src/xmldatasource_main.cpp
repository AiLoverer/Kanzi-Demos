#include <kanzi/kanzi.hpp>

#if !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
#include <xmldatasource_module.hpp>
#endif

// [CodeBehind libs inclusion]. Do not remove this identifier.

#if defined(XML_DATA_SOURCE_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
#include <xml_data_source_code_behind_module.hpp>
#endif

using namespace kanzi;

// Application class.
// Implements application logic.
class XMLDataSourceApplication : public ExampleApplication
{
protected:

    // Configures application.
    void onConfigure(ApplicationProperties& configuration) override
    {
        configuration.binaryName = "xml_data_source.kzb.cfg";
        configuration.defaultWindowProperties.width = 1920;
        configuration.defaultWindowProperties.height = 720;
    }

    // Initializes application after project has been loaded.
    void onProjectLoaded() override
    {
        // Code to run after the .KZB has been loaded.
    }

    void registerMetadataOverride(ObjectFactory& factory) override
    {
        ExampleApplication::registerMetadataOverride(factory);

#if !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
        Domain* domain = getDomain();
        XMLDataSourceModule::registerModule(domain);
#endif

#if defined(XML_DATA_SOURCE_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
        XMLDataSourceCodeBehindModule::registerModule(getDomain());
#endif

        // [CodeBehind module inclusion]. Do not remove this identifier.
    }
};


// Creates application instance. Called by framework.
Application* createApplication()
{
    return new XMLDataSourceApplication();
}
