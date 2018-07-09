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
import android.widget.TextView;

import aero.developer.bagnet.R;
import aero.developer.bagnet.interfaces.Cognex_Setup_Reset_Interface;

/**
 * Created by User on 26-Oct-17.
 */

public class Cognex_Setup_Barcode_Dialog extends DialogFragment {
    private static Cognex_Setup_Barcode_Dialog mInstance = null;
    private static Cognex_Setup_Reset_Interface cognex_setup_reset_interface;

    public static Cognex_Setup_Barcode_Dialog getInstance(Cognex_Setup_Reset_Interface cognex_setup_barcode_dialog) {
        if (mInstance == null) {
            mInstance = new Cognex_Setup_Barcode_Dialog();
            cognex_setup_reset_interface = cognex_setup_barcode_dialog;
        }
        return mInstance;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(STYLE_NO_FRAME, R.style.AppTheme);
    }

    public View onCreateView(final LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        final View layout = inflater.inflate(R.layout.cognex_setup_barcode_dialog, container, false);
        return layout;
    }


    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        Toolbar toolbar = (Toolbar) view.findViewById(R.id.toolbar);
        toolbar.setTitle(getResources().getString(R.string.spp_mode));
        toolbar.setTitleTextColor(getResources().getColor(R.color.white));

        toolbar.setNavigationIcon(R.drawable.back);
        toolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();

            }
        });

        TextView reset=(TextView) view.findViewById(R.id.reset);
        reset.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
                if(cognex_setup_reset_interface !=null) {
                    cognex_setup_reset_interface.OpenResetDialog();
                }
            }
        });
    }

    @Override
    public void onResume() {
        super.onResume();
        getDialog().setOnKeyListener(new DialogInterface.OnKeyListener() {
            @Override
            public boolean onKey(DialogInterface dialogInterface, int keyCode, KeyEvent keyEvent) {
                if (keyCode ==  android.view.KeyEvent.KEYCODE_BACK)
                {
                    dismiss();

                }
                return false;
            }
        });
    }

}

