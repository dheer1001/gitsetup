package aero.developer.bagnet.dialogs;

import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.LayerDrawable;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.DialogFragment;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.text.InputFilter;
import android.text.InputType;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.CustomViews.CostumEditText;
import aero.developer.bagnet.CustomViews.HeaderTextView;
import aero.developer.bagnet.R;
import aero.developer.bagnet.scantypes.EngineActivity;
import aero.developer.bagnet.utils.DataManUtils;
import aero.developer.bagnet.utils.Preferences;

public class BagContainer_InputDialog extends DialogFragment {
    CostumEditText input_barcode;
    HeaderTextView txt_example;
    private boolean isViewForBag = false;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(STYLE_NO_FRAME, R.style.AppTheme);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);


    }

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootview = inflater.inflate(R.layout.bagcontainer_input_dialog, container, false);
        if (getDialog() != null && getDialog().getWindow() != null) {
            getDialog().getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
            getDialog().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE | WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);

        }
        RelativeLayout mainContainer = rootview.findViewById(R.id.mainContainer);
        ImageView ic_close = rootview.findViewById(R.id.ic_close);
        input_barcode = rootview.findViewById(R.id.input_barcode);
        txt_example = rootview.findViewById(R.id.txt_example);

        input_barcode.setFilters(new InputFilter[]{new InputFilter.AllCaps()});

        ic_close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                View focus = getDialog().getCurrentFocus();
                if (focus != null) {
                    InputMethodManager imm = (InputMethodManager)getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                    if (imm != null) {
                        imm.hideSoftInputFromWindow(focus.getWindowToken(), 0);
                    }
                }
                dismiss();

            }
        });

        if (Preferences.getInstance().getIsCode128Enabled(getContext())) {
            setviewForContainer();
        }
        if (Preferences.getInstance().getIs2of5Enabled(getContext())) {
            setviewForBags();
        }

        input_barcode.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView textView, int actionId, KeyEvent keyEvent) {
                if (actionId == EditorInfo.IME_ACTION_DONE) {
                    String barcode = input_barcode.getText().toString();
                    EngineActivity activity = null;
                    if (getActivity() instanceof EngineActivity) {
                        activity = (EngineActivity) getActivity();
                    }

                    if (isViewForBag) {
                        boolean isvalidBag = DataManUtils.isValidBag(barcode);
                        if (isvalidBag) {
                            if (activity != null) {
                                dismiss();
                                activity.onBarcodeScanned(barcode);
                            }
                        } else {
                            input_barcode.setError(getString(R.string.invalid_bag_number));
                        }
                    } else {
                        boolean isValidContainerWithoutSpaces = DataManUtils.checkifThisContainerWithoutSpaces(barcode);
                        boolean isValidContainer = DataManUtils.isValidContainer(barcode);
                        if (isValidContainerWithoutSpaces || isValidContainer) {
                            if (activity != null) {
                                dismiss();
                                activity.onBarcodeScanned(barcode);
                            }
                        } else {
                            input_barcode.setError(getString(R.string.invalid_container_code));
                        }
                    }
                }
                return false;
            }
        });

        //adjust colors
        if (Preferences.getInstance().isNightMode(getContext())) {
            mainContainer.setBackgroundColor(AppController.getInstance().getPrimaryGrayColor());
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                DrawableCompat.setTint(ic_close.getDrawable(), AppController.getInstance().getPrimaryColor());
            } else {
                ic_close.setImageDrawable(AppController.getTintedDrawable(ic_close.getDrawable(), AppController.getInstance().getPrimaryColor()));
            }
            input_barcode.setTextColor(AppController.getInstance().getPrimaryColor());
            input_barcode.setHintTextColor(AppController.getInstance().getSecondaryGrayColor());
            txt_example.setTextColor(AppController.getInstance().getSecondaryGrayColor());
            LayerDrawable input_barcode_background = (LayerDrawable) input_barcode.getBackground().mutate();
            GradientDrawable input_barcode_background_dash = (GradientDrawable) input_barcode_background.findDrawableByLayerId(R.id.dash);
            input_barcode_background_dash.setStroke(1,AppController.getInstance().getSecondaryGrayColor());

        }

        return rootview;
    }

    private void setviewForBags() {
        isViewForBag = true;
        input_barcode.setHint(getResources().getString(R.string.input_bagtag_hint));
        txt_example.setText(getResources().getString(R.string.input_bagtag_example));
        input_barcode.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS | InputType.TYPE_CLASS_NUMBER);
    }

    private void setviewForContainer() {
        isViewForBag = false;
        input_barcode.setHint(getResources().getString(R.string.input_container_hint));
        txt_example.setText(getResources().getString(R.string.input_container_example));
        input_barcode.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS | InputType.TYPE_CLASS_TEXT);
    }
}
