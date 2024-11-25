package com.example.androidgettingstarted;

import static com.rightware.kanzi.Log.*;

import android.os.Bundle;
import android.view.View;

import androidx.appcompat.app.AppCompatActivity;

import com.rightware.kanzi.Domain;
import com.rightware.kanzi.KanziView;
import com.rightware.kanzi.KanziViewListener;
import com.rightware.kanzi.Log;
import com.rightware.kanzi.Node;
import com.rightware.kanzi.ObjectRef;
import com.rightware.kanzi.TextBlock2D;
import com.rightware.kanzi.Node2D;
import com.rightware.kanzi.Button2D;
import android.content.Intent;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle icicle) {
        super.onCreate(icicle);

        // Inflate activity contents from its layout.
        setContentView(R.layout.activity_main);

        // Get a reference to your View.
        KanziView view = findViewById(R.id.textblock);
        // Add state change callbacks to the View.
        view.addListener(new KanziViewListener() {

            @Override
            public void onAttachedToWindow(View view, Domain domain) {
                // Create a Text Block 2D node named "Text Block 2D".
                ObjectRef<TextBlock2D> textBlockRef = TextBlock2D.create(domain, "Text Block 2D");
                TextBlock2D textBlock = textBlockRef.get();
                // Set the Text Block 2D node as the root of the Kanzi view.
                ((KanziView) view).setRoot(textBlock);
                // Position the Text Block 2D node in the center of the Kanzi view.
                textBlock.setProperty(Node.HorizontalAlignmentProperty, Node.HorizontalAlignment.Center);
                textBlock.setProperty(Node.VerticalAlignmentProperty, Node.VerticalAlignment.Center);
                // Set the size of the font of the Text Block 2D node.
                textBlock.setProperty(TextBlock2D.SizeProperty, 90.0f);
                // Set the text that the Text Block 2D node shows.
                textBlock.setText("Hello Kanzi!");
            }

        });

        KanziView view2 = findViewById(R.id.androidgettingstartedview);
        view2.addListener(new KanziViewListener() {
            @Override
            public void onAttachedToWindow(View view, Domain domain) {
            }

            @Override
            public void onStartupPrefabLoaded(View view, Domain domain) {
                Log.debug("MainActivityonStartupPrefabLoaded---------------------");
                // Get the RootPage root node.
                Node2D root = ((KanziView) view).getRoot();
                // Get and set up the button to transition to the SecondActivity.
                Button2D button = root.lookupNode("#Button");
                // Position the Button node in the bottom of the Kanzi view.
                button.setProperty(Node.VerticalAlignmentProperty, Node.VerticalAlignment.Bottom);
                // Set the Button node to go to the second activity when user clicks the button.
                button.addMessageFilter(Button2D.ClickMessage, messageArguments -> {
                    Intent intent = new Intent(((View) view).getContext(), SecondActivity.class);
                    startActivity(intent);
                });
            }
        });

    }


}
