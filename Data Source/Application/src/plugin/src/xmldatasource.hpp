// Copyright 2008-2024 by Rightware. All rights reserved.

#ifndef XMLDATASOURCE_HPP
#define XMLDATASOURCE_HPP

// Use kanzi.hpp only when you are learning to develop Kanzi applications.
// To improve compilation time in production projects, include only the header files of the Kanzi functionality you are using.
#include <kanzi/kanzi.hpp>

using namespace kanzi;


class XMLDataSource;
typedef shared_ptr<XMLDataSource> XMLDataSourceSharedPtr;

// The template component.
class XML_DATA_SOURCE_API XMLDataSource : public DataSource
{
public:

    // Create the XmlFilename property type. You use this property type to tell the data source plugin which XML file to read.
    static PropertyType<string> XmlFilenameProperty;

    KZ_METACLASS_BEGIN(XMLDataSource, DataSource, "XML_data_source")
        // Add the property you created to the class metadata.
        KZ_METACLASS_PROPERTY_TYPE(XmlFilenameProperty)
    KZ_METACLASS_END()

    // Creates the property editor info for the DataSourcePlugin.
    static kanzi::PropertyTypeEditorInfoSharedPtr makeEditorInfo();

    // Creates a DataSourcePlugin.
    static XMLDataSourceSharedPtr create(Domain* domain, string_view name)
    {
        XMLDataSourceSharedPtr xMLDataSource = make_polymorphic_shared_ptr<DataSource>(new XMLDataSource(domain, name));

        xMLDataSource->initialize();

        return xMLDataSource;
    }

    // Destructor
    ~XMLDataSource();

    // Return the data model of this data source.
    DataObjectSharedPtr getData() override
    {
        return m_root;
    }

protected:

    // Constructor.
    explicit XMLDataSource(Domain* domain, string_view name) :
        DataSource(domain, name),
        m_workerThreadExitCondition(false)
    {
    }

    // Initializes the created Kanzi Engine plugin.
    // Kanzi node classes typically have a static create() member function, which creates the instance of a node,
    // initializes it, and returns a shared pointer to the instance. To initialize an instance of a Kanzi Engine 
    // plugin, in the create() function call the initialize() function on the instance of that Kanzi Engine plugin. 
    // You must initialize a node in the initialize() function, not in the constructor.
    void initialize()
    {
        // Initialize base class.
        DataSource::initialize();

        // Here you can initialize your class.
    }

    // Declare the function that parses the XML file and creates data objects from its content.
    void parseFile(vector<char> fileData);

    // Kanzi calls onLoaded after loading the kzb file of the application.
    void onLoaded() override;

private:

    // Declare the function that starts the thread which monitors and reads the XML file.
    void startWorkerThread(string_view filename);

    // Declare the function that stops the thread which monitors and reads the XML file.
    void stopWorkerThread();

    // Declare the function that is executed in the thread which monitors and reads the XML file.
    // You pass a copy of the string for the filename because it is used in a different thread.
    void workerThreadCallback(string filename);

    // Introduce the pointer to the root data object of the data source.
    DataObjectSharedPtr m_root;

    // Introduce the thread for monitoring and reading the XML file.
    thread m_workerThread;

    // Introduce the exit flag for the worker thread.
    atomic<bool> m_workerThreadExitCondition;
};


#endif