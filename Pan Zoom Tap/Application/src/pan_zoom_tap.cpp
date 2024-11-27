// Use kanzi.hpp only when you are learning to develop Kanzi applications.
// To improve compilation time in production projects, include only the header files of the Kanzi functionality you are using.
#include <kanzi/kanzi.hpp>

// [CodeBehind libs inclusion]. Do not remove this identifier.

#if defined(PAN_ZOOM_TAP_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
#include <pan_zoom_tap_code_behind_module.hpp>
#endif

using namespace kanzi;

class PanZoomTap : public ExampleApplication
{
public:

    void onConfigure(ApplicationProperties& configuration) override
    {
        configuration.binaryName = "pan_zoom_tap.kzb.cfg";
        configuration.defaultWindowProperties.width = 1280;
        configuration.defaultWindowProperties.height = 720;
    }

    void onProjectLoaded() override
    {
        // Pointer to the domain.
        Domain* domain = getDomain();

        // Get the Screen node.
        ScreenSharedPtr screen = getScreen();

        // Get the Map node using its alias.
        Node2DSharedPtr mapNode = screen->lookupNode<Node2D>("#Map");

        // Get the reference to the prefab template Pin which shows the pin icon.
        ResourceManager* resourceManager = domain->getResourceManager();
        PrefabTemplateSharedPtr pinPrefabTemplate = resourceManager->acquireResource<PrefabTemplate>("kzb://pan_zoom_tap/Prefabs/Pin");

        // Instantiate the Pin prefab.
        m_pin = pinPrefabTemplate->instantiate<Node2D>("Pin");

        // Add to the Map node the instance of the Pin prefab you created.
        mapNode->addChild(m_pin);

        // Disable the Visible property of the Pin prefab instance.
        // You enable the Visible property when the user drops a pin.
        m_pin->setVisible(false);

        // Subscribe to the PanManipulator::MovedMessage message at the Map node.
        // The PanManipulator generates this message when the user moves the pointer on the horizontal or
        // vertical axis more than the recognition threshold and when the pointer moves between updates.
        mapNode->addMessageHandler(PanManipulator::MovedMessage, bind(&PanZoomTap::onPanMoved, this, placeholders::_1));

        // Create an input manipulator that generates pinch messages.
        PinchManipulatorSharedPtr pinchManipulator = PinchManipulator::create(domain);

        // Add the input manipulator to the Map node.
        mapNode->addInputManipulator(pinchManipulator);

        // Subscribe to the PinchManipulator::StartedMessage message at the Map node.
        // The PinchManipulator generates this message when the user presses two fingers on the Map node.
        mapNode->addMessageHandler(PinchManipulator::StartedMessage, bind(&PanZoomTap::onPinchStarted, this, placeholders::_1));

        // Subscribe to the PinchManipulator::MovedMessage message at the Map node.
        // The PinchManipulator generates this message when the scale or rotation threshold is exceeded
        // and when the tracked touches move between updates.
        mapNode->addMessageHandler(PinchManipulator::MovedMessage, bind(&PanZoomTap::onPinchMoved, this, placeholders::_1));

        // Subscribe to the MultiClickManipulator::MultiClickMessage message at the Map node.
        // The MultiClickManipulator manipulator generates this message when the user double-taps the Map node.
        mapNode->addMessageHandler(MultiClickManipulator::MultiClickMessage, bind(&PanZoomTap::onNodeDoubleTapped, this, placeholders::_1));

        // Subscribe to the LongPressManipulator::LongPressMessage message at the Map node.
        // The LongPressManipulator manipulator generates this message when the user presses the Map node
        // for the amount of milliseconds you set in the LongPressManipulator::setPressDuration function.
        mapNode->addMessageHandler(LongPressManipulator::LongPressMessage, bind(&PanZoomTap::onLongPress, this, placeholders::_1));
    }

    // Update the scale and rotation of the Pin prefab instance.
    void updatePinScaleAndRotation(SRTValue2D mapSRT, SRTValue2D pinSRT)
    {
        // Set the rotation to be the negative of the rotation of the Map node.
        pinSRT.setRotation(-mapSRT.getRotation());

        // Set the scale to be the inverse of the scale of the Map node.
        pinSRT.setScale(componentWiseDivide(Vector2(1.0f, 1.0f), mapSRT.getScale()));

        // Apply the render transformation to the Pin prefab instance.
        m_pin->setRenderTransformation(pinSRT);
    }

    void registerMetadataOverride(ObjectFactory& factory) override
    {
        ExampleApplication::registerMetadataOverride(factory);

#if defined(PAN_ZOOM_TAP_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
        PanZoomTapCodeBehindModule::registerModule(getDomain());
#endif

        // [CodeBehind module inclusion]. Do not remove this identifier.
    }

private:
    // Define the handler for the PinchManipulator::StartedMessage message from the 2D nodes
    // that have an input manipulator which generates pinch messages.
    // This handler prepares a 2D node for a pinch gesture.
    void onPinchStarted(PinchManipulator::StartedMessageArguments& messageArguments)
    {
        // Get from the message arguments the node that the user pinches.
        Node2DSharedPtr mapNode = dynamic_pointer_cast<Node2D>(messageArguments.getSource());

        // Store the initial value of the Render Transformation property Scale property field.
        SRTValue2D nodeTransform = mapNode->getRenderTransformation();
        m_pinchInitialScaleFactor = nodeTransform.getScale().getX() - 1.0f;

        // Calculate a minimum scale value based on the size of the application screen.
        ScreenSharedPtr screen = getScreen();
        m_minScale = max(getScreen()->getActualWidth() / mapNode->getActualWidth(), screen->getActualHeight() / mapNode->getActualHeight());
    }
    // Define the handler for the PanManipulator::MovedMessage message from 2D nodes
    // that have an input manipulator which generates pan messages.
    // This handler translates a 2D node for the amount of the pan gesture.
    void onPanMoved(PanManipulator::MovedMessageArguments& messageArguments)
    {
        // Get from the message arguments the node that the user pans.
        Node2DSharedPtr mapNode = dynamic_pointer_cast<Node2D>(messageArguments.getSource());

        // Get the distance in pixels for which the pan progressed
        // since the last message in the pan gesture sequence.
        Vector2 translationDelta = messageArguments.getDelta();

        // Get the Render Transformation property of the Map node.
        SRTValue2D mapNodeSRT = mapNode->getRenderTransformation();

        // Get the current translation of the Map node.
        Vector2 translation = mapNodeSRT.getTranslation();

        // Apply the translation from the pan message.
        Vector2 translationTarget = translation + translationDelta;

        // Get the parent node of the Map node.
        Node2D* containerNode = dynamic_cast<Node2D*>(mapNode->getParent());

        // Get the size of the parent node.
        Vector2 containerSize = containerNode->getActualSize();

        // Get the Render Transformation property Scale property field of the Map node.
        Vector2 mapScale = mapNodeSRT.getScale();

        // Calculate the scaled size of the Map node.
        Vector2 mapSizeScaled = componentWiseMultiply(mapNode->getActualSize(), mapScale);

        // Do not pan outside the boundaries of the Map node.
        // When calculating the boundaries, take into account the current scale of the map.
        if (mapScale.getX() >= 1.0f)
        {
            translationTarget = componentWiseMax(componentWiseMin(translationTarget, (mapSizeScaled - containerSize) / 2), (containerSize - mapSizeScaled) / 2);
        }
        else if (mapScale.getX() < 1.0f)
        {
            translationTarget = componentWiseMin(componentWiseMax(translationTarget, (containerSize - mapSizeScaled) / 2), (mapSizeScaled - containerSize) / 2);
        }

        // Set the new translation.
        mapNodeSRT.setTranslation(translationTarget);

        // Apply the new transform to the Map node.
        mapNode->setRenderTransformation(mapNodeSRT);
    }

    // Define the handler for the LongPressManipulator::LongPressMessage message from the nodes
    // that have an input manipulator which generates the long-press message.
    void onLongPress(LongPressManipulator::LongPressMessageArguments& messageArguments)
    {
        // Get from the message arguments the node that the user long-presses.
        Node2DSharedPtr mapNode = dynamic_pointer_cast<Node2D>(messageArguments.getSource());

        // Get the point where the user long-pressed.
        Vector2 pointerPosition = messageArguments.getPoint();

        // Create a render transformation that contains the translation to the point where the user long-pressed.
        SRTValue2D pinSRT = SRTValue2D::createTranslation(pointerPosition);

        // Position the tip of the pin where the user long-pressed.
        pinSRT.setTranslation(pinSRT.getTranslation() - Vector2(m_pin->getActualWidth() * 0.5f, m_pin->getActualHeight() * 0.8f));

        // Apply the transformation to the Pin prefab instance.
        //m_pin->setRenderTransformation(pinSRT);

        // Get the Render Transformation property of the Map node.
        SRTValue2D mapSRT = mapNode->getRenderTransformation();

        // Update the scale and position of the Pin prefab instance.
        updatePinScaleAndRotation(mapSRT, pinSRT);

        // Enable the Visible property of the Pin prefab instance.
        m_pin->setVisible(true);
    }

    // Define the handler for the MultiClickManipulator::MultiClickMessage message from the nodes that have
    // an input manipulator which generates the multi-click message when the user double-taps the node.
    void onNodeDoubleTapped(MultiClickManipulator::MultiClickMessageArguments& messageArguments)
    {
        // Get from the message arguments the node that the user double-taps.
        Node2DSharedPtr mapNode = dynamic_pointer_cast<Node2D>(messageArguments.getSource());

        // Remove the Render Transformation property of the node.
        // This way you reset the position, zoom level, and rotation angle of the Map node.
        mapNode->removeLocalValue(Node2D::RenderTransformationProperty);

        // Reset the rotation and scale of the Pin prefab instance.
        SRTValue2D pinSRT = m_pin->getRenderTransformation();
        pinSRT = SRTValue2D(Vector2(1.0f, 1.0f), 0, pinSRT.getTranslation());
        m_pin->setRenderTransformation(pinSRT);
    }

    // Define the handler for the PinchManipulator::MovedMessage message from the 2D nodes
    // that have an input manipulator which generates pinch messages.
    // This scales and rotates a 2D node for the amount of the pinch gesture.
    void onPinchMoved(PinchManipulator::MovedMessageArguments& messageArguments)
    {
        // Get from the message arguments the node that the user pinches.
        Node2DSharedPtr mapNode = dynamic_pointer_cast<Node2D>(messageArguments.getSource());

        // Get the scale and rotation from the message arguments.
        float scaleDelta = messageArguments.getScale();
        float rotateDelta = messageArguments.getRotation();

        // Calculate the scale by adding the initial scale to the pinch value.
        // Restrict the scale so that the map cannot be smaller than the application screen size.
        float scale = max(m_minScale, scaleDelta + m_pinchInitialScaleFactor);

        // Get the Render Transformation property of the Map node.
        SRTValue2D mapRenderSRT = mapNode->getRenderTransformation();

        // Apply the rotation.
        mapRenderSRT.rotate(rotateDelta);

        // Apply the scale.
        mapRenderSRT.setScale(Vector2(scale, scale));

        // Get the world transformation of the Map node.
        // You use this in the next step of the tutorial.
        Matrix3x3 mapWorldTransform = mapNode->getWorldTransform();

        optional<SRTValue2D> mapWorldSRT = SRTValue2D::create(mapWorldTransform);
        kzAssert(mapWorldSRT);

        // Apply the new render transformation to the Map node.
        mapNode->setRenderTransformation(mapRenderSRT);

        // Get the Render Transformation property of the Pin prefab instance.
        SRTValue2D pinSRT = m_pin->getRenderTransformation();

        // Update the scale and position of the Pin prefab instance.
        updatePinScaleAndRotation(*mapWorldSRT, pinSRT);
    }
    // Define a member variable for the Pin prefab instance.
    Node2DSharedPtr m_pin;
    // Define a member variable for the initial scale factor of the pinch gesture.
    float m_pinchInitialScaleFactor;

    // Define a member variable for the minimum scale value.
    float m_minScale;
};

Application* createApplication()
{
    return new PanZoomTap;
}
