// Use kanzi.hpp only when you are learning to develop Kanzi applications.
// To improve compilation time in production projects, include only the header files of the Kanzi functionality you are using.
#include <kanzi/kanzi.hpp>

// [CodeBehind libs inclusion]. Do not remove this identifier.

#if defined(DRAG_AND_DROP_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
#include <drag_and_drop_code_behind_module.hpp>
#endif

using namespace kanzi;

class DragAndDrop : public ExampleApplication
{
public:

    void onConfigure(ApplicationProperties& configuration) override
    {
        configuration.binaryName = "drag_and_drop.kzb.cfg";
    }

    void onProjectLoaded() override
    {
        // Project file has been loaded from .kzb file.

        // Add initialization code here.

        Domain* domain = getDomain();

        // Create a data object named Root.
        m_rootData = DataObject::create(domain, "Root");

        // Create data objects and add them to the Root data object.
        // Add to each of the data objects a string data object which contains the kzb URL of a texture.
        // In the Kanzi Studio project you can find the textures in the Library > Materials and Textures > Textures.
        DataObjectSharedPtr item0 = DataObject::create(domain, "item0");
        m_rootData->addChild(item0);
        item0->addChild(DataObjectString::create(domain, "image", "kzb://drag_and_drop/Textures/Navigation"));

        DataObjectSharedPtr item1 = DataObject::create(domain, "item1");
        m_rootData->addChild(item1);
        item1->addChild(DataObjectString::create(domain, "image", "kzb://drag_and_drop/Textures/Phone"));

        DataObjectSharedPtr item2 = DataObject::create(domain, "item2");
        m_rootData->addChild(item2);
        item2->addChild(DataObjectString::create(domain, "image", "kzb://drag_and_drop/Textures/Applications Home"));

        DataObjectSharedPtr item3 = DataObject::create(domain, "item3");
        m_rootData->addChild(item3);
        item3->addChild(DataObjectString::create(domain, "image", "kzb://drag_and_drop/Textures/Sound Loud"));

        DataObjectSharedPtr item4 = DataObject::create(domain, "item4");
        m_rootData->addChild(item4);
        item4->addChild(DataObjectString::create(domain, "image", "kzb://drag_and_drop/Textures/Car Wheel"));

        // Get the Screen node.
        ScreenSharedPtr screen = getScreen();

        // Set the Data Context property of the Screen node to the Root data object.
        // By setting the Data Context property you tell your application from which data source it receives data.
        screen->setProperty(DataContext::DataContextProperty, m_rootData);

        // Get the parent Grid Layout 2D node of the node that the user is dragging.
        m_grid = screen->lookupNode<GridLayout2D>("#Grid Layout 2D");

        updateItems();

        // Get the reference to the Drag Item prefab.
        ResourceManager* resourceManager = getDomain()->getResourceManager();
        PrefabTemplateSharedPtr dragItemPrefab = resourceManager->acquireResource<PrefabTemplate>("kzb://drag_and_drop/Prefabs/Drag Item");

        // Instantiate the Drag Item prefab.
        m_dragItem = dragItemPrefab->instantiate<Node2D>("Drag Item");

        // Get the RootPage node using its alias.
        Node2DSharedPtr rootPage = screen->lookupNode<Node2D>("#RootPage");

        // Add to the RootPage node the instance of the Drag Item prefab that you created.
        rootPage->addChild(m_dragItem);

        // Disable the Visible property of the Drag Item prefab instance.
        // You hide the Drag Item when the user is not dragging it.
        m_dragItem->setVisible(false);

        // Create a drag-and-drop manipulator for each button.
        // You get the button nodes using their aliases.
        createDragAndDropManipulator(screen->lookupNode<Node>("#Navigation"));
        createDragAndDropManipulator(screen->lookupNode<Node>("#Phone"));
        createDragAndDropManipulator(screen->lookupNode<Node>("#Applications"));
        createDragAndDropManipulator(screen->lookupNode<Node>("#Music"));
        createDragAndDropManipulator(screen->lookupNode<Node>("#Car"));
    }

    void registerMetadataOverride(ObjectFactory& factory) override
    {
        ExampleApplication::registerMetadataOverride(factory);

#if defined(DRAG_AND_DROP_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
        DragAndDropCodeBehindModule::registerModule(getDomain());
#endif

        // [CodeBehind module inclusion]. Do not remove this identifier.
    }

    // Define the handler for the DragAndDropManipulator::MovedMessage message from 2D nodes
// that have an input manipulator which generates drag-and-drop messages.
    void onDragMoved(DragAndDropManipulator::MovedMessageArguments& messageArguments)
    {
        // Get from the message arguments the button that the user is dragging.
        Node2DSharedPtr dragSourceItem = dynamic_pointer_cast<Node2D>(messageArguments.getSource());

        // Move the Drag Item and update the icons of the buttons.
        updateDragAndDrop(messageArguments.getPoint(), dragSourceItem->getWorldTransform());
    }

    // Create and configure a drag-and-drop manipulator for a node.
    void createDragAndDropManipulator(NodeSharedPtr dragSourceItem)
    {
        Domain* domain = getDomain();

        // Create an input manipulator that generates drag-and-drop messages.
        DragAndDropManipulatorSharedPtr dragAndDropManipulator = DragAndDropManipulator::create(domain);

        // Add the input manipulator to the node.
        dragSourceItem->addInputManipulator(dragAndDropManipulator);

        // Set the duration of the long press before the drag-and-drop starts to 200 ms. The default is 500 ms.
        // This is the amount of time the user must press the node before they can start dragging it.
        dragAndDropManipulator->setPressDuration(chrono::milliseconds(200));

        // Subscribe to the DragAndDropManipulator::StartedMessage message at the node.
        // The DragAndDropManipulator generates this message when the user presses the node
        // for the duration set by DragAndDropManipulator::setPressDuration.
        dragSourceItem->addMessageHandler(DragAndDropManipulator::StartedMessage, bind(&DragAndDrop::onDragStarted, this, placeholders::_1));

        // Subscribe to the DragAndDropManipulator::MovedMessage message at the node.
        // The DragAndDropManipulator generates this message when the pointer moves.
        dragSourceItem->addMessageHandler(DragAndDropManipulator::MovedMessage, bind(&DragAndDrop::onDragMoved, this, placeholders::_1));

        // Subscribe to the DragAndDropManipulator::FinishedMessage message at the node.
        // The DragAndDropManipulator generates this message when the user ends the drag-and-drop gesture
        // by releasing the pointer.
        dragSourceItem->addMessageHandler(DragAndDropManipulator::FinishedMessage, bind(&DragAndDrop::onDragFinished, this, placeholders::_1));
    }
private:

    // To assign correct icons to the buttons, set the Data Context property for each button.
    void updateItems()
    {
        // Create an iterator that iterates through the data objects in the Root data object.
        DataObject::ChildConstIterator dataIt = m_rootData->beginChildren(), endDataIt = m_rootData->endChildren();

        // Create an iterator that iterates through the buttons which are
        // child nodes of the Navigation Bar > Grid Layout 2D node.
        Node2D::ChildConstIterator nodeIt = m_grid->beginChildren();

        // Set the Data Context property of each button node to the correct data object.
        for (; dataIt != endDataIt; dataIt++, nodeIt++)
        {
            Node2DSharedPtr itemNode = *nodeIt;
            DataObjectSharedPtr itemData = *dataIt;
            itemNode->setProperty(DataContext::DataContextProperty, itemData);

            // If the button node is the one that the user is dragging, hide it.
            // You hide the node because you use the Drag Item to visualize the dragging of the node.
            if (m_draggedDataContext && itemData == m_draggedDataContext)
            {
                itemNode->setVisible(false);
            }
            else
            {
                itemNode->setVisible(true);
            }
        }
    }

    // Update the position of the Drag Item.
    void updateDragAndDrop(Vector2 dragPosition, Matrix3x3 dragWorldTransform)
    {
        // Calculate the local drag anchor that is the top-left corner of the button that the user is dragging.
        Vector2 localDragAnchor = dragPosition - m_dragGrabOffset;

        // Restrict the movement of the Drag Item to the x axis.
        localDragAnchor.setY(0.0f);

        // Calculate the global drag anchor.
        Vector2 globalDragAnchor = dragWorldTransform * localDragAnchor;

        // The structure that you use to describe the Render Transformation property of the Drag Item.
        SRTValue2D transform;
        // Set the Render Transformation property Translation property field to the global drag anchor.
        transform.setTranslation(globalDragAnchor);

        // Move the Drag Item for the amount of the dragged distance.
        m_dragItem->setRenderTransformation(transform);


        // Get the global pointer position.
        Vector2 globalPointerPosition = dragWorldTransform * dragPosition;

        // Convert global coordinates to local coordinates of the Grid Layout 2D node.
        Vector2 hitTestPoint = *m_grid->globalToLocal(globalPointerPosition);

        // Get the width of the button.
        float cellWidth = m_grid->getActualColumnSize(0);

        // Calculate the index of the button in the Grid Layout 2D node.
        unsigned int cellIndex = 0;

        if (hitTestPoint.getX() > 0.0f)
        {
            cellIndex = floatToUint(hitTestPoint.getX() / cellWidth);
            cellIndex = min(cellIndex, static_cast<unsigned int>(m_grid->getChildCount() - 1u));
        }

        // Remove the data object from the old position.
        m_rootData->removeChild(*m_draggedDataContext);

        // Insert the data object to the new position.
        m_rootData->insertChild(cellIndex, m_draggedDataContext);


        // Set the icons of the buttons.
        updateItems();
    }

    // Define the handler for the DragAndDropManipulator::StartedMessage message from 2D nodes
    // that have an input manipulator which generates drag-and-drop messages.
    // This prepares the 2D node for dragging.
    void onDragStarted(DragAndDropManipulator::StartedMessageArguments& messageArguments)
    {
        // Get from the message arguments the button that the user starts to drag.
        Node2DSharedPtr dragSourceItem = dynamic_pointer_cast<Node2D>(messageArguments.getSource());

        // Get the size of the button that the user starts to drag.
        Vector2 dragSourceItemSize = dragSourceItem->getActualSize();

        // Set the size of the Drag Item to be the same as the size of that button.
        m_dragItem->setSize(dragSourceItemSize.getX(), dragSourceItemSize.getY());

        // Get the data context object of the button that the user starts to drag.
        m_draggedDataContext = dynamic_pointer_cast<DataObject>(dragSourceItem->getProperty(DataContext::DataContextProperty));

        // Set the Data Context property of the Drag Item to the data context of the button.
        // This way you set the Drag Item to have the same icon as the button that the user starts to drag.
        m_dragItem->setProperty(DataContext::DataContextProperty, m_draggedDataContext);

        // Save the point from which the user started dragging the node,
        // relative to the origin (by default the top-left corner) of the node.
        m_dragGrabOffset = messageArguments.getPoint();

        // Move the Drag Item to the correct position.
        updateDragAndDrop(messageArguments.getPoint(), dragSourceItem->getWorldTransform());

        // Make the Drag Item visible.
        m_dragItem->setVisible(true);


    }

    // Define the handler for the DragAndDropManipulator::FinishedMessage message from 2D nodes
    // that have an input manipulator which generates drag-and-drop messages.
    void onDragFinished(DragAndDropManipulator::FinishedMessageArguments&)
    {
        // Hide the Drag Item prefab instance.
        m_dragItem->setVisible(false);

        // Clear the pointer to the data context object.
        m_draggedDataContext.reset();

        // Assign the correct icons to the buttons.
        updateItems();
    }

    // Define a member variable for the Grid Layout 2D node.
    GridLayout2DSharedPtr m_grid;
    // Define a member variable for the instantiated Drag Item.
    Node2DSharedPtr m_dragItem;
    // Define a member variable for the offset from the top-left corner of the button where the user pressed down or clicked it.
    Vector2 m_dragGrabOffset;
    // Define a member variable for the data context object of the button that the user drags.
    DataObjectSharedPtr m_draggedDataContext;
private:

    // Define a member variable for the Root data object.
    DataObjectSharedPtr m_rootData;

};

Application* createApplication()
{
    return new DragAndDrop;
}
