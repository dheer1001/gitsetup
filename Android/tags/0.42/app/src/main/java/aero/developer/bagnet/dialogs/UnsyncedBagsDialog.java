package aero.developer.bagnet.dialogs;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import java.util.List;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.CustomViews.CustomButton;
import aero.developer.bagnet.CustomViews.HeaderTextView;
import aero.developer.bagnet.LoginActivity;
import aero.developer.bagnet.R;
import aero.developer.bagnet.objects.BagTag;
import aero.developer.bagnet.objects.LoginResponse;
import aero.developer.bagnet.utils.BagTagDBHelper;
import aero.developer.bagnet.utils.Preferences;

public class UnsyncedBagsDialog extends DialogFragment {

    private HeaderTextView txt_description;
    private ImageView bagTagImage;
    private RelativeLayout bagTagLayout, mainContainer;
    private LoginResponse loginReponse;
    private LoginActivity loginActivity;
    private List<BagTag> bagTagList;

    public void setLoginReponse(LoginActivity loginActivity, LoginResponse loginReponse) {
        this.loginActivity = loginActivity;
        this.loginReponse = loginReponse;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootview = inflater.inflate(R.layout.unsynced_bags_dialog, container, false);
        setCancelable(false);

        HeaderTextView txt_bagsNumber = (HeaderTextView) rootview.findViewById(R.id.txt_bagsNumber);
        txt_description = (HeaderTextView) rootview.findViewById(R.id.txt_description);
        CustomButton btn_sendFromAccount = (CustomButton) rootview.findViewById(R.id.btn_sendFromAccount);
        CustomButton btn_cancel = (CustomButton) rootview.findViewById(R.id.btn_cancel);
        CustomButton btn_delete = (CustomButton) rootview.findViewById(R.id.btn_delete);
        bagTagImage = (ImageView) rootview.findViewById(R.id.bagTagImage);
        bagTagLayout = (RelativeLayout) rootview.findViewById(R.id.bagTagLayout);
        mainContainer = (RelativeLayout) rootview.findViewById(R.id.mainContainer);

        WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
        Window window = getDialog().getWindow();
        if (window != null) {
            lp.copyFrom(window.getAttributes());
            lp.width = WindowManager.LayoutParams.MATCH_PARENT;
            lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
            window.setAttributes(lp);
            window.setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
        }

        bagTagList = BagTagDBHelper.getInstance(getContext()).getBagtagTag().queryBuilder().list();

        int Nb_BagsNotSynced = 0;
        for (BagTag item : bagTagList) {
            if (!item.getSynced()) {
                Nb_BagsNotSynced += 1;
            }
        }
        txt_bagsNumber.setText(String.valueOf(Nb_BagsNotSynced));
        txt_description.setText(getResources().getString(R.string.login_queueUnsyncedBags, Preferences.getInstance().getUserID(getContext())));
        btn_sendFromAccount.setOnClickListener(continueListener);
        btn_cancel.setOnClickListener(dismissListener);
        btn_delete.setOnClickListener(deleteListener);

        if (Preferences.getInstance().isNightMode(getContext())) {
            adjustColors();
        }
        return rootview;
    }

    private View.OnClickListener continueListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            loginActivity.whatToDoAfterSuccessfulLoginReponse(loginReponse);
            dismiss();
        }
    };

    private View.OnClickListener dismissListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            dismiss();
        }
    };

    private View.OnClickListener deleteListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            new AlertDialog.Builder(getContext(), R.style.Theme_AppCompat_DayNight_Dialog_Alert)
                    .setTitle("Warning")
                    .setMessage(getResources().getString(R.string.login_queue_action_deleteUnsynced_prompt))
                    .setCancelable(false)
                    .setPositiveButton("YES", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            if (bagTagList != null && bagTagList.size() > 0) {
                                for (BagTag item : bagTagList) {
                                    BagTagDBHelper.getInstance(getContext()).getBagtagTag().delete(item);
                                }
                                loginActivity.whatToDoAfterSuccessfulLoginReponse(loginReponse);
                            }
                            dismiss();
                        }
                    })
                    .setNegativeButton("cancel", null)
                    .show();
        }
    };

    private void adjustColors() {
        GradientDrawable main_container_drawable = (GradientDrawable) mainContainer.getBackground();
        main_container_drawable.setStroke(4, AppController.getInstance().getSecondaryGrayColor());
        main_container_drawable.setColor(AppController.getInstance().getbagDetailBackground());

        txt_description.setTextColor(AppController.getInstance().getPrimaryColor());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            bagTagImage.getDrawable().setTint(AppController.getInstance().getbagImageColor());
        } else {
            bagTagImage.setImageDrawable(AppController.getTintedDrawable(bagTagImage.getDrawable(), AppController.getInstance().getbagImageColor()));
        }

        GradientDrawable bagTagLayout_drawable = (GradientDrawable) bagTagLayout.getBackground();
        bagTagLayout_drawable.setStroke(4, AppController.getInstance().getSecondaryColor());
        bagTagLayout_drawable.setColor(AppController.getInstance().getbagContainerColor());

    }
}
