// Copyright 2008-2024 by Rightware. All rights reserved.

#include <kanzi/kanzi.hpp>

// [CodeBehind libs inclusion]. Do not remove this identifier.

#if defined(LOCALIZATION_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
#include <localization_code_behind_module.hpp>
#endif

using namespace kanzi;

class LocalizationApplication : public ExampleApplication
{
public:

    void onConfigure(ApplicationProperties& configuration) override
    {
        configuration.binaryName = "Localization.kzb.cfg";
        configuration.defaultWindowProperties.width = 1920;
        configuration.defaultWindowProperties.height = 1080;
    }

    void onProjectLoaded() override
    {
        // Set the name of the directory where you stored the locale packs.
        static const string localizationFolderName = "Locale_packs";

        // Get the Screen node in the kzb file. You use the Screen node to access all the other nodes and resources in the kzb file.
        ScreenSharedPtr screen = getScreen();
        // Domain is a collection of all subsystems and contains the Kanzi resource manager. You need to get the resource manager to access the resources in the kzb file.
        ResourceManager* resourceManager = getDomain()->getResourceManager();

        // Get the LocaleSelector node which contains the locale selection buttons.
        // Access alias target nodes using the # sign followed by the name of the alias.
        Node2DSharedPtr localeSelector = screen->lookupNode<Node2D>("#LocaleSelector");

        // Get the LocaleButton prefabricated template used for the buttons that set the locale.
        // Get the reference to the template using the kzb URL.
        // When you use the full path of a resource, start the path with kzb:// followed by the project name and the location of the resource.
        PrefabTemplateSharedPtr localeButtonPrefab = resourceManager->acquireResource<PrefabTemplate>("kzb://localization/Prefabs/LocaleButton");

        // Get the custom property type for setting the name of the locale in the
        // LocaleButton node. You created this custom property type in the Kanzi Studio project.
        DynamicPropertyType<string> localeNameProperty = DynamicPropertyType<string>("Localization.LocaleName");

        // Get the custom property type for setting the locale in the application.
        // You created this custom property type in the Kanzi Studio project.
        DynamicPropertyType<string> localeIdProperty = DynamicPropertyType<string>("Localization.LocaleID");

        // Read the binaries.cfg file that contains the list of the kzb files
        // that contain the locale packs.
        string configFileName = localizationFolderName + "/binaries.cfg";
        ReadOnlyDiskFile binariesConfigFile(configFileName);
        string binariesConfigContents = readAsText(binariesConfigFile);
        stringstream binariesConfigFileStream(binariesConfigContents);

        string localeId;

        // Load the resources stored in the locale pack kzb files.
        while (getline(binariesConfigFileStream, localeId))
        {
            trim(localeId);

            // Create the path for the kzb file.
            string localizationKzbFilePath = localizationFolderName + "/" + localeId + ".kzb";

            // Add the kzb file to the Kanzi resource manager.
            getResourceManager()->addKzbFile(localizationKzbFilePath);

            string dictionaryUrl = "kzb://localization/Locales/" + localeId;
            ResourceDictionarySharedPtr localeDictionary = getResourceManager()->acquireResource<ResourceDictionary>(dictionaryUrl);

            // Instantiate the LocaleButton prefab.
            Node2DSharedPtr localeButton = localeButtonPrefab->instantiate<Node2D>("LocaleButton_" + localeId);

            // Get the name of the locale that is shown in the application from the
            // resource ID LocaleDisplayName stored in the localization table in the locale pack.
            TextResourceSharedPtr localeDisplayNameResource = localeDictionary->acquire<TextResource>(ResourceID("LocaleDisplayName"));

            std::string sName = localeDisplayNameResource->getText();
            // Set the LocaleName property so that the Text Block 2D node in the button shows the name of the locale.
            localeButton->setProperty(localeNameProperty, localeDisplayNameResource->getText());
            // Set the LocaleID property so that when you click the button the application changes to that locale.
            localeButton->setProperty(localeIdProperty, localeId);

            // Set the style of the Text Block 2D node in the button so that it sets
            // the correct font for the LocaleDisplayName of the locale.
            // Use this approach only to apply a style from the locale pack without changing the locale
            // in the application.
            optional<string> localeStyle = localeDictionary->find(ResourceID("LocaleStyle"));
            StyleSharedPtr style = getResourceManager()->acquireResource<Style>(*localeStyle);
            localeButton->setStyle(style);

            // Add the LocaleButton node to the LocaleSelector node.
            localeSelector->addChild(localeButton);
        }
    }

    void registerMetadataOverride(ObjectFactory& factory) override
    {
        ExampleApplication::registerMetadataOverride(factory);

#if defined(LOCALIZATION_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
        LocalizationCodeBehindModule::registerModule(getDomain());
#endif

        // [CodeBehind module inclusion]. Do not remove this identifier.
    }
};

Application* createApplication()
{
    return new LocalizationApplication;
}
