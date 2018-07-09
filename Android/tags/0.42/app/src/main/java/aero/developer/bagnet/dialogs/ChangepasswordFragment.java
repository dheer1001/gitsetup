package aero.developer.bagnet.dialogs;

import android.content.DialogInterface;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.v4.app.DialogFragment;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.support.v7.widget.AppCompatEditText;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.Constants;
import aero.developer.bagnet.CustomViews.CustomButton;
import aero.developer.bagnet.LoginActivity;
import aero.developer.bagnet.R;
import aero.developer.bagnet.interfaces.ChangePasswordActions;
import aero.developer.bagnet.objects.ChangePasswordResponse;
import aero.developer.bagnet.objects.LoginData;
import aero.developer.bagnet.presenters.ChangePasswordPresenter;
import aero.developer.bagnet.utils.Preferences;
import retrofit2.Response;

/**
 * Created by Mohamad Itani on 11-Oct-17.
 */

public class ChangepasswordFragment extends DialogFragment implements ChangePasswordActions {
    private TextView txt_reset_password, txt_back, subtitle;
    private ScrollView scrollView;
    private ImageView ic_lock,userimageView,companyimageView,oldPasswordimageView,newPasswordimageView,confirmPasswordimageView,ic_back;
    private View view1,view2,view3,view4,view5;
    private RelativeLayout userID_container,company_container,oldPassword_container,newPassword_container,confirmPassword_container;
    private CustomButton btn_changePassword;
    private AppCompatEditText input_companyId,input_userId,input_oldPassword,input_newPassword,input_confirmPassword;
    private LinearLayout progressbarContainer;
    String password_regex;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(STYLE_NO_FRAME, R.style.AppTheme);
    }

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootview = inflater.inflate(R.layout.reset_password_fragment, container, false);

        if(getDialog() != null && getDialog().getWindow() != null) {
            getDialog().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE
            );

        }
        scrollView = rootview.findViewById(R.id.scrollView);
        LinearLayout backContainer = rootview.findViewById(R.id.backContainer);
        txt_reset_password = rootview.findViewById(R.id.txt_reset_password);
        subtitle = rootview.findViewById(R.id.subtitle);
        input_userId = rootview.findViewById(R.id.input_userId);
        input_companyId = rootview.findViewById(R.id.input_companyId);
        input_oldPassword = rootview.findViewById(R.id.input_oldPassword);
        input_newPassword = rootview.findViewById(R.id.input_newPassword);
        input_confirmPassword = rootview.findViewById(R.id.input_confirmPassword);

        view1 = rootview.findViewById(R.id.view1);
        view2 = rootview.findViewById(R.id.view2);
        view3 = rootview.findViewById(R.id.view3);
        view4 = rootview.findViewById(R.id.view4);
        view5 = rootview.findViewById(R.id.view5);

        userID_container = rootview.findViewById(R.id.userID_container);
        company_container = rootview.findViewById(R.id.company_container);
        oldPassword_container = rootview.findViewById(R.id.oldPassword_container);
        newPassword_container = rootview.findViewById(R.id.newPassword_container);
        confirmPassword_container = rootview.findViewById(R.id.confirmPassword_container);

        btn_changePassword = rootview.findViewById(R.id.btn_changePassword);
        txt_back = rootview.findViewById(R.id.txt_back);

        ic_back = rootview.findViewById(R.id.ic_back);
        ic_lock = rootview.findViewById(R.id.ic_lock);
        userimageView = rootview.findViewById(R.id.userimageView);
        companyimageView = rootview.findViewById(R.id.companyimageView);
        oldPasswordimageView = rootview.findViewById(R.id.oldPasswordimageView);
        newPasswordimageView = rootview.findViewById(R.id.newPasswordimageView);
        confirmPasswordimageView = rootview.findViewById(R.id.confirmPasswordimageView);
        progressbarContainer = rootview.findViewById(R.id.progressbarContainer);
        input_oldPassword.addTextChangedListener(mTextWatcher);
        input_newPassword.addTextChangedListener(mTextWatcher);
        input_confirmPassword.addTextChangedListener(mTextWatcher);
        input_oldPassword.requestFocus();

        View verticalview = rootview.findViewById(R.id.verticalview);
        boolean showSubtitle = false;
        if (getArguments() != null) {
            showSubtitle = getArguments().getBoolean("showSubtitle");
        }
        if (showSubtitle) {
            subtitle.setVisibility(View.VISIBLE);
            verticalview.setVisibility(View.GONE);
        } else {
            subtitle.setVisibility(View.GONE);
            verticalview.setVisibility(View.VISIBLE);
        }

        password_regex = "^(?=.{8,24})(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[ ~!@#$%^&*_=+|';:,<.>/?]).*$";

        input_newPassword.setFilters(new InputFilter[] {new InputFilter.LengthFilter(24)});
        input_confirmPassword.setFilters(new InputFilter[] {new InputFilter.LengthFilter(24)});

        btn_changePassword.setOnClickListener(changePasswordListener);
        backContainer.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
               dismiss();
            }
        });
        adjustColors();
        return rootview;
    }

    @Override
    public void onResume() {
        super.onResume();
        input_userId.setText(Preferences.getInstance().getUserID(getContext()));
        input_companyId.setText(Preferences.getInstance().getCompanyID(getContext()));
    }

    private View.OnClickListener changePasswordListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            String new_password  = input_newPassword.getText().toString();
            String confirm_password  = input_confirmPassword.getText().toString();

            if(new_password.equals(confirm_password) && checkRegex(input_newPassword.getText().toString())
            && checkRegex(input_confirmPassword.getText().toString())) {
                progressbarContainer.setVisibility(View.VISIBLE);
                ChangePasswordPresenter presenter = new ChangePasswordPresenter(getContext(),ChangepasswordFragment.this);
                presenter.changePasswordApi();
            }else if(!new_password.equals(confirm_password)) {
                ApiResponseDialog.getInstance().showDialog(getResources().getString(R.string.passwordDialogNotMatch), false, true, true, Constants.CHANGE_PASSWORD_MESSAGE_TIME, false);
            } else if (!checkRegex(input_newPassword.getText().toString()) || !checkRegex(input_confirmPassword.getText().toString())) {
                ApiResponseDialog.getInstance().showDialog(getResources().getString(R.string.passwordDialogNotValid), false, true, true, Constants.CHANGE_PASSWORD_MESSAGE_TIME, false);
            }
        }
    };
    private void adjustColors() {

        scrollView.setBackgroundColor(AppController.getInstance().getSecondaryColor());

        txt_back.setTextColor(AppController.getInstance().getPrimaryColor());
        txt_reset_password.setTextColor(AppController.getInstance().getPrimaryColor());

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            DrawableCompat.setTint(ic_back.getDrawable(), AppController.getInstance().getPrimaryColor());
            DrawableCompat.setTint(ic_lock.getDrawable(), AppController.getInstance().getPrimaryColor());
            DrawableCompat.setTint(userimageView.getDrawable(), AppController.getInstance().getPrimaryColor());
            DrawableCompat.setTint(companyimageView.getDrawable(), AppController.getInstance().getPrimaryColor());
            DrawableCompat.setTint(oldPasswordimageView.getDrawable(), AppController.getInstance().getPrimaryColor());
            DrawableCompat.setTint(confirmPasswordimageView.getDrawable(), AppController.getInstance().getPrimaryColor());
            DrawableCompat.setTint(newPasswordimageView.getDrawable(), AppController.getInstance().getPrimaryColor());
        } else {
            ic_back.setImageDrawable(AppController.getTintedDrawable(ic_back.getDrawable(),AppController.getInstance().getPrimaryColor()));
            ic_lock.setImageDrawable(AppController.getTintedDrawable(ic_lock.getDrawable(),AppController.getInstance().getPrimaryColor()));
            userimageView.setImageDrawable(AppController.getTintedDrawable(userimageView.getDrawable(),AppController.getInstance().getPrimaryColor()));
            companyimageView.setImageDrawable(AppController.getTintedDrawable(companyimageView.getDrawable(),AppController.getInstance().getPrimaryColor()));
            oldPasswordimageView.setImageDrawable(AppController.getTintedDrawable(oldPasswordimageView.getDrawable(),AppController.getInstance().getPrimaryColor()));
            confirmPasswordimageView.setImageDrawable(AppController.getTintedDrawable(confirmPasswordimageView.getDrawable(),AppController.getInstance().getPrimaryColor()));
            newPasswordimageView.setImageDrawable(AppController.getTintedDrawable(newPasswordimageView.getDrawable(),AppController.getInstance().getPrimaryColor()));
        }

        btn_changePassword.setTextColor(AppController.getInstance().getPrimaryColor());

        GradientDrawable btn_changePassword_drawable = (GradientDrawable)btn_changePassword.getBackground();
        btn_changePassword_drawable.setStroke(1,AppController.getInstance().getSecondaryGrayColor());

        GradientDrawable serviceID_drawable = (GradientDrawable)userID_container.getBackground();
        serviceID_drawable.setColor(AppController.getInstance().getPrimaryGrayColor());

        GradientDrawable airline_drawable = (GradientDrawable)company_container.getBackground();
        airline_drawable.setColor(AppController.getInstance().getPrimaryGrayColor());

        GradientDrawable oldPassword_container_drawable = (GradientDrawable)oldPassword_container.getBackground();
        oldPassword_container_drawable.setColor(AppController.getInstance().getPrimaryGrayColor());

        GradientDrawable newPassword_container_drawable = (GradientDrawable)newPassword_container.getBackground();
        newPassword_container_drawable.setColor(AppController.getInstance().getPrimaryGrayColor());

        GradientDrawable confirmPassword_container_drawable = (GradientDrawable)confirmPassword_container.getBackground();
        confirmPassword_container_drawable.setColor(AppController.getInstance().getPrimaryGrayColor());


        view1.setBackgroundColor(AppController.getInstance().getSecondaryGrayColor());
        view2.setBackgroundColor(AppController.getInstance().getSecondaryGrayColor());
        view3.setBackgroundColor(AppController.getInstance().getSecondaryGrayColor());
        view4.setBackgroundColor(AppController.getInstance().getSecondaryGrayColor());
        view5.setBackgroundColor(AppController.getInstance().getSecondaryGrayColor());

        input_userId.setTextColor(AppController.getInstance().getPrimaryColor());
        input_userId.setHintTextColor(AppController.getInstance().getPrimaryColor());

        input_companyId.setTextColor(AppController.getInstance().getPrimaryColor());
        input_companyId.setHintTextColor(AppController.getInstance().getPrimaryColor());

        input_oldPassword.setTextColor(AppController.getInstance().getPrimaryColor());
        input_oldPassword.setHintTextColor(AppController.getInstance().getSecondaryGrayColor());

        input_newPassword.setTextColor(AppController.getInstance().getPrimaryColor());
        input_newPassword.setHintTextColor(AppController.getInstance().getSecondaryGrayColor());

        input_confirmPassword.setTextColor(AppController.getInstance().getPrimaryColor());
        input_confirmPassword.setHintTextColor(AppController.getInstance().getSecondaryGrayColor());

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                checkFieldsForEmptyValues();

            }
        },200);

    }


    @Override
    public AppCompatEditText getOldPasswordView() {
        return this.input_oldPassword;
    }

    @Override
    public AppCompatEditText getnewPasswordView() {
        return this.input_newPassword;
    }

    @Override
    public AppCompatEditText getconfirmPasswordView() {
        return this.input_confirmPassword;
    }


    private TextWatcher mTextWatcher = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence charSequence, int i, int i2, int i3) {
        }

        @Override
        public void onTextChanged(CharSequence charSequence, int i, int i2, int i3) {
        }

        @Override
        public void afterTextChanged(Editable editable) {
            checkFieldsForEmptyValues();
        }
    };



        void checkFieldsForEmptyValues(){
        String s1 = input_oldPassword.getText().toString();
        String s2 = input_newPassword.getText().toString();
        String s3 = input_confirmPassword.getText().toString();


        if(!s1.equals("") && !s2.equals("") && !s3.equals("")) {
            btn_changePassword.setTextColor(AppController.getInstance().getPrimaryColor());
            btn_changePassword.setEnabled(true);
        }else {
            btn_changePassword.setTextColor(AppController.getInstance().getSecondaryGrayColor());
            btn_changePassword.setEnabled(false);
        }

    }

    private boolean checkRegex(String str) {

       if( str.matches(password_regex) && str.length()>=8 && str.length()<=24 ){
           return true;
       }else {
           return false;
       }
    }

    @Override
    public void onChangeSuccess(Response<ChangePasswordResponse> response) {
        progressbarContainer.setVisibility(View.GONE);
        input_oldPassword.setText("");
        input_newPassword.setText("");
        input_confirmPassword.setText("");
        String message = response.body().getSuccess_message();
        if(getActivity() instanceof LoginActivity) {
            message +=". "+ getString(R.string.reset_password_success_extra);
        }

        ApiResponseDialog.getInstance().setChangePasswordInstance(ChangepasswordFragment.this);
        ApiResponseDialog.instance.showDialog(message, true, true, true, Constants.ResponseDialogExpireTime, true);
    }

    public void closeAndDismiss() {
        dismiss();
        if (SettingsDialog.getInstance() != null) {
            SettingsDialog.getInstance().dismiss();
        }
    }

    @Override
    public void onChangeFailed(String message) {
        progressbarContainer.setVisibility(View.GONE);
        ApiResponseDialog.getInstance().showDialog(message, false, true, true, Constants.CHANGE_PASSWORD_MESSAGE_TIME, false);
    }

    @Override
    public void onDismiss(DialogInterface dialog) {
        super.onDismiss(dialog);
        input_userId.setText("");
        input_companyId.setText("");
        input_oldPassword.setText("");
        input_newPassword.setText("");
        input_confirmPassword.setText("");
    }
}
