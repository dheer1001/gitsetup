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

public class Setup_Barcode_Dialog extends DialogFragment {
    private static Setup_Barcode_Dialog mInstance = null;
    private static Reset_Setup_Interface reset_setup_interface;

    public static Setup_Barcode_Dialog getInstance(Reset_Setup_Interface _reset_setup_interface) {
        if (mInstance == null) {
            mInstance = new Setup_Barcode_Dialog();
            reset_setup_interface=_reset_setup_interface;
        }
        return mInstance;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(STYLE_NO_FRAME, R.style.AppTheme);
    }

    public View onCreateView(final LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        final View layout = inflater.inflate(R.layout.setup_barcode, container, false);
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
                if(reset_setup_interface!=null){
                    reset_setup_interface.Connection();
                }
            }
        });

        TextView reset=(TextView) view.findViewById(R.id.reset);
        reset.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
                if(reset_setup_interface!=null) {
                    reset_setup_interface.OpenResetDialog();
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
                    if(reset_setup_interface!=null){
                        reset_setup_interface.Connection();
                    }
                }
                return false;
            }
        });
    }

}
