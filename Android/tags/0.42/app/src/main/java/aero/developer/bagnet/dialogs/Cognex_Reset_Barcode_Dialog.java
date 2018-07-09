package aero.developer.bagnet.dialogs;

import android.content.DialogInterface;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.DialogFragment;
import android.support.v7.widget.Toolbar;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import aero.developer.bagnet.R;

/**
 * Created by User on 26-Oct-17.
 */

public class Cognex_Reset_Barcode_Dialog  extends DialogFragment {

    private static Cognex_Reset_Barcode_Dialog mInstance = null;

    public static Cognex_Reset_Barcode_Dialog getInstance() {
        if (mInstance == null) {
            mInstance = new Cognex_Reset_Barcode_Dialog();
        }
        return mInstance;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(STYLE_NO_FRAME, R.style.AppTheme);
    }


    public View onCreateView(final LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        final View layout = inflater.inflate(R.layout.cognex_reset_barcode_dialog, container, false);
        Toolbar toolbar = (Toolbar) layout.findViewById(R.id.toolbar);
        toolbar.setTitle(getResources().getString(R.string.resetScanner));
        toolbar.setTitleTextColor(getResources().getColor(R.color.white));
        return layout;
    }


    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        Toolbar toolbar = (Toolbar) view.findViewById(R.id.toolbar);
        toolbar.setNavigationIcon(R.drawable.back);
        toolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });

    }

    @Override
    public void onResume() {
        super.onResume();
        getDialog().setOnKeyListener(new DialogInterface.OnKeyListener() {
            @Override
            public boolean onKey(DialogInterface dialogInterface, int keyCode, KeyEvent keyEvent) {
                if (keyCode == android.view.KeyEvent.KEYCODE_BACK) {
                    dismiss();
                }
                return false;
            }
        });
    }
}
