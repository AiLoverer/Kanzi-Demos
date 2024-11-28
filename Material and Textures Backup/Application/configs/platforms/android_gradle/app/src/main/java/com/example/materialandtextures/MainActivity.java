package com.example.materialandtextures;

import android.os.Bundle;
import android.view.View;

import androidx.appcompat.app.AppCompatActivity;

import com.rightware.kanzi.Domain;
import com.rightware.kanzi.KanziView;
import com.rightware.kanzi.KanziViewListener;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle icicle) {
        super.onCreate(icicle);

        // Inflate activity contents from its layout.
        setContentView(R.layout.activity_main);

        // Get a reference to your View.
        KanziView view = findViewById(R.id.materialandtexturesview);

        // Add state change callbacks to the View.
        view.addListener(new KanziViewListener() {
            @Override
            public void onAttachedToWindow(View view, Domain domain) {
                KanziGenerated.registerPlugins(domain);
            }

            @Override
            public void onStartupPrefabLoaded(View view, Domain domain) {
            }
        });
    }
}
