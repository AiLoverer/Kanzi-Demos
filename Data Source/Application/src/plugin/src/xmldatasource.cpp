// Copyright 2008-2024 by Rightware. All rights reserved.

#include "xmldatasource.hpp"
// Provides the functionality to process XML.
#include "tinyxml2.h"
// Provides the system utility function to get the timestamp of the file.
#include <sys/stat.h>
// Provides the functionality for creating data objects for a static list.
#include "data_object_static_list.hpp"

// Declare the addDataObjectsRecursively function.
static void addDataObjectsRecursively(Domain* domain, DataObjectSharedPtr object, const tinyxml2::XMLElement* xml);

// Read the contents of the XML file into memory.
vector<char> readFileContents(string_view filename)
{
    ReadOnlyDiskFile file(filename);
    vector<char> data(static_cast<size_t>(file.size()));
    file.read(data.data(), data.size());

    return data;
}

// Creates the property editor info for the DataSourcePlugin.
PropertyTypeEditorInfoSharedPtr XMLDataSource::makeEditorInfo()
{
    return PropertyTypeEditorInfoSharedPtr(
        KZ_DECLARE_EDITOR_METADATA(
            metadata.displayName = "XML data source";
        ));
}

// Destructor
XMLDataSource::~XMLDataSource()
{
    // Shut down the thread that monitors and reads the XML file.
    stopWorkerThread();
}

// Kanzi calls onLoaded after loading the kzb file of the application.
void XMLDataSource::onLoaded()
{
    // The Kanzi Studio Preview can call the onLoaded function multiple times whenever
    // the user edits properties of the data source or refreshes the data source.
    // Shut down the thread that monitors and reads the XML file.
    stopWorkerThread();

    // If you do not set the value of the XML Data Source File property, the plugin does not do anything.
    string filename = getProperty(XmlFilenameProperty);
    if (!filename.empty())
    {
        // Call the function that reads the contents of the XML file into memory, and pass the return value 
        // to the function that parses the XML file and creates data objects from its content.
        parseFile(readFileContents(filename));

        // Start the thread that monitors and reads the XML file.
        startWorkerThread(filename);
    }
}

// Helper function to get the file modification time.
static time_t getFileModificationTime(const char* filename)
{
    time_t result = 0;

    struct stat fs;
    if (stat(filename, &fs) == 0)
    {
        result = fs.st_mtime;
    }

    return result;
}

// Start the thread that monitors and reads the XML file.
void XMLDataSource::startWorkerThread(string_view filename)
{
    kzAssert(!m_workerThread.joinable());

    m_workerThread = thread(&XMLDataSource::workerThreadCallback, this, string(filename));
}

// Stop the thread that monitors and reads the XML file.
void XMLDataSource::stopWorkerThread()
{
    m_workerThreadExitCondition = true;

    if (m_workerThread.joinable())
    {
        m_workerThread.join();
    }

    m_workerThreadExitCondition = false;
}

// This thread function checks once every second whether the XML file has been modified.
// The function reads the contents of the XML file and submits a task to the UI thread to parse the file contents
// into the data source structure.
void XMLDataSource::workerThreadCallback(string filename)
{
    TaskDispatcher* taskDispatcher = getDomain()->getTaskDispatcher();

    // Initialize the previous modification time to an invalid value.
    time_t oldModificationTime = static_cast<time_t>(-1);

    for (;;)
    {
        if (!filename.empty())
        {
            time_t newModificationTime = getFileModificationTime(filename.c_str());

            if (oldModificationTime != newModificationTime)
            {
                // Read the contents of the file into memory.
                // You read the file contents on this thread to avoid blocking the UI thread with a long operation.
                vector<char> data = readFileContents(filename);

                // Submit a task that parses the XML file and constructs the data source.
                // You must do this in the UI thread because you can manipulate data source objects
                // and other UI objects only in the UI thread.
                taskDispatcher->submit(bind(&XMLDataSource::parseFile, this, kanzi::move(data)));

                oldModificationTime = newModificationTime;
            }
        }

        // Sleep for one second.
        this_thread::sleep_for(chrono::milliseconds(1000));

        // If the UI thread sets the exit flag, exit.
        if (m_workerThreadExitCondition)
        {
            break;
        }
    }
}

// Parse the XML file and create data objects from its content.
void XMLDataSource::parseFile(vector<char> fileData)
{
    // Clear the previous data object tree.
    m_root.reset();

    // Parse the XML document from the memory and release the open file.
    tinyxml2::XMLDocument doc;
    tinyxml2::XMLError error = doc.Parse(fileData.data(), fileData.size());

    // If the plugin successfully loads the file set in the XML Data Source File property, create data objects.
    if (error == tinyxml2::XML_SUCCESS)
    {
        // Get the root XML element.
        const tinyxml2::XMLElement* element = doc.RootElement();
        // Create the root data object of the data source.
        m_root = DataObject::create(getDomain(), "Root");
        do
        {
            // Populate the child data objects of the root data object.
            addDataObjectsRecursively(getDomain(), m_root, element);
            // Handle all sibling elements of the root XML element.
            element = element->NextSiblingElement();
        } while (element);

        notifyModified();
    }
}

// Use this function to add list items to a list data object.
static void addListItems(Domain* domain, DataObjectStaticListSharedPtr list, const tinyxml2::XMLElement* itemsElement)

{
    for (const tinyxml2::XMLElement* child = itemsElement->FirstChildElement(); child; child = child->NextSiblingElement())
    {
        // Create the root data object for the list item hierarchy.
        DataObjectSharedPtr rootObject = DataObject::create(domain, "Item root");
        // Create the list item tree recursively.
        addDataObjectsRecursively(domain, rootObject, child);
        // Add the first child from the root data object as a list item. Discard the root object.
        list->addItem(rootObject);
    }
}

// Add a data object of the type specified by the type attribute in the XML element. Get the initial value
// from the text parameter.
DataObjectSharedPtr addDataObject(Domain *domain, const char* type, const char* name, const char* text)
{
    shared_ptr<DataObject> object;
    // Create an integer data object from the int type attributes.
    if (type && strcmp(type, "int") == 0)
    {
        int value = 0;
        if (text)
        {
            value = atoi(text);
        }
        object = DataObjectInt::create(domain, name, value);
    }
    // Create a float data object from the float and real type attributes.
    else if (type && (strcmp(type, "real") == 0 || strcmp(type, "float") == 0))
    {
        double value = 0;
        if (text)
        {
            value = atof(text);
        }
        object = DataObjectReal::create(domain, name, value);
    }
    // Create a Boolean data object from the bool and boolean type attributes.
    else if (type && (strcmp(type, "bool") == 0 || strcmp(type, "boolean") == 0))
    {
        bool value = false;
        if (text)
        {
            value = (strcmp(text, "true") == 0);
        }
        object = DataObjectBool::create(domain, name, value);
    }
    // Create a string data object from the string type attributes.
    else if (type && strcmp(type, "string") == 0)
    {
        string value;
        if (text)
        {
            value = text;
        }
        object = DataObjectString::create(domain, name, value);
    }
    // Create a list data object from the list type attributes.
    else if (type && strcmp(type, "list") == 0)
    {
        object = make_shared<DataObjectStaticList>(domain, name);
    }
    else
    {
        // If the type attribute is not set, create a generic data object.
        // This is used to create the hierarchy in the data source.
        object = DataObject::create(domain, name);
    }
    return object;
}

// Convert to data objects the content of the XML structure in memory. You use these data objects to
// construct the data object tree of the data source.
// - The second parameter sets the node where this pass places new data objects. 
// - The third parameter sets the pointer to the location where the conversion and parsing is progressing (within the
// XML in the memory, the child element in the XML).
static void addDataObjectsRecursively(Domain* domain, DataObjectSharedPtr parent, const tinyxml2::XMLElement* xml)
{
    // Check whether the current element in the XML file has the type attribute set.
    const tinyxml2::XMLAttribute* typeAttribute = xml->FindAttribute("type");

    // Get value of the type attribute.
    const char* type = 0;
    if (typeAttribute)
    {
        type = typeAttribute->Value();
    }

    // Create the data object based on the value of the type attribute.
    DataObjectSharedPtr object = addDataObject(domain, type, xml->Name(), xml->GetText());
    // Add the data object as a child to the parent data object.
    parent->addChild(object);

    // Check whether the type of the current data object is list.
    DataObjectStaticListSharedPtr list = dynamic_pointer_cast<DataObjectStaticList>(object);
    // Traverse the tree in the XML file to add data objects for each child element of the current XML element.
    for (const tinyxml2::XMLElement* child = xml->FirstChildElement(); child; child = child->NextSiblingElement())
    {
        // If the name of the XML element within the list type is items, create data objects inside that list data object.
        if (list && strcmp(child->Name(), "items") == 0)
        {
            addListItems(domain, list, child);
        }
        else
        {
            // Recurse.
            addDataObjectsRecursively(domain, object, child);
        }
    }
}

// Define the metadata for the property type you use to tell the data source plugin which XML file to read.
PropertyType<string> XMLDataSource::XmlFilenameProperty(kzMakeFixedString("XMLdatasource.XMLDataSourceFile"), "", 0, false,
                                                        KZ_DECLARE_EDITOR_METADATA
                                                        (
                                                            // Set the name of the property the way it is shown in Kanzi Studio.
                                                            metadata.displayName = "XML Data Source File";
                                                            // Set the tooltip for the property.
                                                            metadata.tooltip = "Sets which XML file the data source plugin reads.";
                                                            // Select the editor which is used to edit the value of this property type.
                                                            // BrowseFileTextEditor editor contains a text box with a Browse button next to it.
                                                            metadata.editor = "BrowseFileTextEditor";
));