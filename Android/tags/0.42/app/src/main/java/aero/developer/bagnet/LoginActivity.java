package aero.developer.bagnet;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.support.v7.widget.AppCompatEditText;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextWatcher;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.TextView;

import com.google.gson.Gson;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import aero.developer.bagnet.CustomViews.CustomButton;
import aero.developer.bagnet.CustomViews.CustomLoginDrawableBackground;
import aero.developer.bagnet.Sign_In_Timeout.AlarmHelper;
import aero.developer.bagnet.api.ApiCalls;
import aero.developer.bagnet.connectivity.NetworkUtil;
import aero.developer.bagnet.dialogs.ApiResponseDialog;
import aero.developer.bagnet.dialogs.ChangepasswordFragment;
import aero.developer.bagnet.dialogs.PasswordWarningDialog;
import aero.developer.bagnet.dialogs.SelectAirlineFragment;
import aero.developer.bagnet.dialogs.SelectAirportFragment;
import aero.developer.bagnet.dialogs.UnsyncedBagsDialog;
import aero.developer.bagnet.interfaces.PermissionHandler;
import aero.developer.bagnet.loginutils.LoginPresenter;
import aero.developer.bagnet.loginutils.LoginView;
import aero.developer.bagnet.objects.BagTag;
import aero.developer.bagnet.objects.BagTagDao;
import aero.developer.bagnet.objects.LoginRequest;
import aero.developer.bagnet.objects.LoginResponse;
import aero.developer.bagnet.permissions.PermissionActivity;
import aero.developer.bagnet.presenters.TrackingPointPresenter;
import aero.developer.bagnet.scantypes.HoneyWellScanner_Activity;
import aero.developer.bagnet.scantypes.SoftScannerActivity;
import aero.developer.bagnet.socketmobile.TestSocketScannerActivity;
import aero.developer.bagnet.utils.Analytic;
import aero.developer.bagnet.utils.BagTagDBHelper;
import aero.developer.bagnet.utils.Preferences;
import aero.developer.bagnet.utils.Utils;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class LoginActivity extends PermissionActivity implements LoginView, Callback<LoginResponse> {

    float downX,downY,upX,upY;
    AppCompatEditText input_password;
    AppCompatEditText input_userId;
    AppCompatEditText input_companyId;
    TextView version,ColorMode;
    private LoginPresenter presenter;
    Spinner ScannerType;
    String ScannerItem;
    ImageView logo,scanner,passwordimageView,airlineImageView,userimageView,ic_color_mode;
    ScrollView scrollView;
    CustomButton btn_sign_in;
    Boolean isNightMode = false;
    RelativeLayout userID_container,company_container,password_container;
    View view1,view2,view3;
    ArrayAdapter<String> adapter;
    LinearLayout colorModeContainer,scanner_type_container;
    CustomLoginDrawableBackground customLoginDrawableBackground;
    private LinearLayout progressbarContainer;
    LoginResponse loginresponse;
    private View.OnClickListener loginClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            presenter.login();
        }
    };
    private int spinnerSelectedPosition = -1;
    private String deviceName ;
    @SuppressLint("StaticFieldLeak")
    public static LoginActivity loginActivity;

    @SuppressLint("ClickableViewAccessibility")
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login_v2);

        loginActivity = LoginActivity.this;
        presenter = new LoginPresenter(this);

        scrollView = (ScrollView) findViewById(R.id.scrollView);
        logo = (ImageView) findViewById(R.id.logo);
        userimageView = (ImageView) findViewById(R.id.userimageView);
        airlineImageView = (ImageView) findViewById(R.id.airlineImageView);
        passwordimageView = (ImageView) findViewById(R.id.passwordimageView);
        scanner = (ImageView) findViewById(R.id.scanner);
        userID_container = (RelativeLayout) findViewById(R.id.userID_container);
        company_container = (RelativeLayout) findViewById(R.id.company_container);
        password_container = (RelativeLayout) findViewById(R.id.password_container);
        colorModeContainer = (LinearLayout) findViewById(R.id.colorModeContainer);
        ColorMode = (TextView) findViewById(R.id.ColorMode);
        ic_color_mode = (ImageView) findViewById(R.id.ic_color_mode);


        view1 = findViewById(R.id.view1);
        view2 = findViewById(R.id.view2);
        view3 = findViewById(R.id.view3);

        version =(TextView) findViewById(R.id.version);
        ScannerType=(Spinner) findViewById(R.id.input_scanners);

        input_userId = (AppCompatEditText) findViewById(R.id.input_userId);
        input_password = (AppCompatEditText) findViewById(R.id.input_password);
        input_companyId = (AppCompatEditText) findViewById(R.id.input_companyId);

        scanner_type_container = (LinearLayout) findViewById(R.id.scanner_type_container);
        progressbarContainer = (LinearLayout) findViewById(R.id.progressbarContainer);
        Analytic.getInstance().sendScreen(R.string.EVENT_START_SCREEN);


        btn_sign_in = (CustomButton) findViewById(R.id.btn_sign_in);
        customLoginDrawableBackground = (CustomLoginDrawableBackground ) findViewById(R.id.customLoginDrawableBackground);

        input_userId.addTextChangedListener(mTextWatcher);
        input_companyId.addTextChangedListener(mTextWatcher);
        input_password.addTextChangedListener(mTextWatcher);
        checkFieldsForEmptyValues();

        colorModeContainer.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(isNightMode) {
                    isNightMode = false;
                    Preferences.getInstance().setIS_NIGHT_MODE(getApplicationContext(),false);
                }
                else {
                    isNightMode = true;
                    Preferences.getInstance().setIS_NIGHT_MODE(getApplicationContext(),true);
                }
                adjustColors();
            }
        });

        scrollView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {

                switch(event.getAction()){


                    case MotionEvent.ACTION_DOWN:
                    {
                        downX = event.getX();
                        downY = event.getY();
                    }
                    case MotionEvent.ACTION_UP:{
                        upX = event.getX();
                        upY = event.getY();

                        float deltaX = downX - upX;
                        float deltaY = downY - upY;


                        if(( (deltaX >= -100 && deltaX <= 100 )) )
                            return false;



                        if(Math.abs(deltaX)>0){
                            if(deltaX>=0 ){
                                if(isNightMode) {
                                    isNightMode = false;
                                    Preferences.getInstance().setIS_NIGHT_MODE(getApplicationContext(),false);
                                }
                                else {
                                    isNightMode = true;
                                    Preferences.getInstance().setIS_NIGHT_MODE(getApplicationContext(),true);
                                }
                                adjustColors();
                                return true;
                            }else {
                                if(isNightMode) {
                                    isNightMode = false;
                                    Preferences.getInstance().setIS_NIGHT_MODE(getApplicationContext(), false);
                                }
                                else {
                                    isNightMode = true;
                                    Preferences.getInstance().setIS_NIGHT_MODE(getApplicationContext(), true);
                                }
                                adjustColors();
                                return  true;
                            }
                        }
                    }
                }

                return false;
            }
        });


        Utils.setVersion(this, version);

        input_companyId.setFilters(new InputFilter[]{new InputFilter.AllCaps()});
        input_userId.setFilters(new InputFilter[]{new InputFilter.AllCaps()});
        btn_sign_in.setOnClickListener(loginClickListener);

//        List<String> permissionsList = new ArrayList<String>(Arrays.asList(CAMERA, READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE));
//        checkPermission(permissionsList);
    }

    @Override
    public void permissionGranted() {
        super.permissionGranted();
    }

    @Override
    public void permissionDenied() {
        super.permissionDenied();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        loginActivity = null;
        AlarmHelper.getInstance(getApplicationContext()).cancel();
    }

    @Override
    public String getUserId() {
        return input_userId.getText().toString();
    }

    @Override
    public String getPassword() {
        return input_password.getText().toString();
    }

    @Override
    public String getCompanyId() {
        return input_companyId.getText().toString();
    }

    @Override
    public void setUserIdError(int resourceId) {
        if (resourceId > 0) {
            input_userId.setError(getString(resourceId));
        } else {
            input_userId.setError(null);
        }
    }

    @Override
    public void setPasswordError(int resourceId) {
        if (resourceId > 0) {
            input_password.setError(getString(resourceId));
        } else {
            input_password.setError(null);
        }
    }

    @Override
    public void setCompanyIdError(int resourceId) {
        if (resourceId > 0) {
            input_companyId.setError(getString(resourceId));
        } else {
            input_companyId.setError(null);
        }
    }

    @Override
    public boolean isUserIdValid() {
        String regexp = ("^[a-zA-Z0-9]*$");
        return true || getUserId().matches(regexp);
    }


    @Override
    public boolean isCompanyIdValid() {
            String regexp = ("^[a-zA-Z0-9]*$");
            return true || getCompanyId().matches(regexp);
    }

    @Override
    public boolean isPasswordValid() {
        String regexp = ("^[a-zA-Z0-9]*$");
        return true || getPassword().matches(regexp);
    }


    @Override
    protected void onResume() {
        super.onResume();
        Utils.stopScanningService();
        isNightMode = Preferences.getInstance().isNightMode(getApplicationContext());
        if(Preferences.getInstance().getUserID(getApplicationContext())!=null)
            input_userId.setText(Preferences.getInstance().getUserID(getApplicationContext()));

        if(Preferences.getInstance().getCompanyID(getApplicationContext())!=null)
            input_companyId.setText(Preferences.getInstance().getCompanyID(getApplicationContext()));

        scanner_type_container.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ScannerType.performClick();
            }
        });
        deviceName = android.os.Build.MODEL;
        adjustScannerSpinner();
        adjustColors();
    }

    private void adjustScannerSpinner () {
        final String[] stringlist = new String[]{
                getResources().getString(R.string.cognex_scanner),
                getResources().getString(R.string.honeywell_ct50_scanner),
                getResources().getString(R.string.socket_mobile_bt),
                getResources().getString(R.string.soft_scan),
        };
        final ArrayList<String> items = new ArrayList<>(Arrays.asList(stringlist));

        boolean isMXConnectInstalled = appInstalledOrNot();
        if(!isMXConnectInstalled){
            items.remove(getResources().getString(R.string.cognex_scanner));
        }
        if(!deviceName.equalsIgnoreCase("CT50")) {
            items.remove(getResources().getString(R.string.honeywell_ct50_scanner));
        }
        Collections.sort(Arrays.asList(stringlist));
        adapter = new ArrayAdapter<String>(this, R.layout.spinner_textview,items) {
            @Override
            public boolean isEnabled(int position) {
                return !items.get(position).equalsIgnoreCase(getResources().getString(R.string.honeywell_ct50_scanner)) || deviceName.equalsIgnoreCase("CT50");
            }

            @Override
            public View getDropDownView(int position, View convertView,
                                        @NonNull ViewGroup parent) {
                View mView = super.getDropDownView(position, convertView, parent);
                TextView mTextView = (TextView) mView;
                if (mTextView.getText().toString().equalsIgnoreCase(getResources().getString(R.string.honeywell_ct50_scanner))) {
                    if (deviceName.equalsIgnoreCase("CT50")) {
                        mTextView.setTextColor(getResources().getColor(R.color.black));
                    } else {
                        mTextView.setTextColor(getResources().getColor(R.color.disabled_gray));
                    }
                }else {
                    mTextView.setTextColor(getResources().getColor(R.color.black));
                }
                return mView;
            }
        };

        adapter.setDropDownViewResource(R.layout.custom_dropdown_spinner);
        ScannerType.setAdapter(adapter);

        // set spinner selected item
        if (Preferences.getInstance().getScannerType(LoginActivity.this)!=null) {
            spinnerSelectedPosition= adapter.getPosition(Preferences.getInstance().getScannerType(LoginActivity.this));
            ScannerType.setSelection(spinnerSelectedPosition);
        }else {
            if(deviceName.equalsIgnoreCase("CT50")) {
                spinnerSelectedPosition = adapter.getPosition(getResources().getString(R.string.honeywell_ct50_scanner));
                ScannerType.setSelection(spinnerSelectedPosition);
            }else {
                if (!isMXConnectInstalled) {
                    spinnerSelectedPosition = adapter.getPosition(getResources().getString(R.string.soft_scan));;
                    ScannerType.setSelection(spinnerSelectedPosition);
                } else {
                    spinnerSelectedPosition = adapter.getPosition(getResources().getString(R.string.cognex_scanner));;
                    ScannerType.setSelection(spinnerSelectedPosition);
                }
            }
        }
        ScannerType.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                ScannerItem = (String) parent.getItemAtPosition(position);
                if (getResources() != null && parent.getChildAt(0)!=null) {
                    ((TextView) parent.getChildAt(0)).setTextColor(AppController.getInstance().getPrimaryColor());
                }
                spinnerSelectedPosition = position;
            }
            @Override
            public void onNothingSelected(AdapterView<?> parent) {}
        });
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
        String s1 = input_userId.getText().toString();
        String s2 = input_companyId.getText().toString();
        String s3 = input_password.getText().toString();

        if(s1.equals("")|| s2.equals("") || s3.equals("")){
            btn_sign_in.setTextColor(AppController.getInstance().getSecondaryGrayColor());
            btn_sign_in.setEnabled(false);
        } else {
            btn_sign_in.setTextColor(AppController.getInstance().getPrimaryColor());
            btn_sign_in.setEnabled(true);
        }
    }

    private void adjustColors() {
        scrollView.setBackgroundColor(AppController.getInstance().getSecondaryColor());
        version.setTextColor(AppController.getInstance().getPrimaryColor());
        ColorMode.setTextColor(AppController.getInstance().getPrimaryColor());
        if(isNightMode) {
            ic_color_mode.setImageDrawable(getResources().getDrawable(R.drawable.theme_lite));
        }
        else {
            ic_color_mode.setImageDrawable(getResources().getDrawable(R.drawable.theme_dark));
        }

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            DrawableCompat.setTint(logo.getDrawable(), AppController.getInstance().getPrimaryColor());
            DrawableCompat.setTint(userimageView.getDrawable(), AppController.getInstance().getPrimaryColor());
            DrawableCompat.setTint(airlineImageView.getDrawable(), AppController.getInstance().getPrimaryColor());
            DrawableCompat.setTint(passwordimageView.getDrawable(), AppController.getInstance().getPrimaryColor());
            DrawableCompat.setTint(scanner.getDrawable(), AppController.getInstance().getPrimaryColor());
            DrawableCompat.setTint(ic_color_mode.getDrawable(), AppController.getInstance().getPrimaryColor());
        } else {
            logo.setImageDrawable(AppController.getTintedDrawable(logo.getDrawable(),AppController.getInstance().getPrimaryColor()));
            userimageView.setImageDrawable(AppController.getTintedDrawable(userimageView.getDrawable(),AppController.getInstance().getPrimaryColor()));
            airlineImageView.setImageDrawable(AppController.getTintedDrawable(airlineImageView.getDrawable(),AppController.getInstance().getPrimaryColor()));
            passwordimageView.setImageDrawable(AppController.getTintedDrawable(passwordimageView.getDrawable(),AppController.getInstance().getPrimaryColor()));
            scanner.setImageDrawable(AppController.getTintedDrawable(scanner.getDrawable(),AppController.getInstance().getPrimaryColor()));
            ic_color_mode.setImageDrawable(AppController.getTintedDrawable(ic_color_mode.getDrawable(),AppController.getInstance().getPrimaryColor()));
        }

        btn_sign_in.setTextColor(AppController.getInstance().getPrimaryColor());

        GradientDrawable btn_sign_in_drawable = (GradientDrawable)btn_sign_in.getBackground();
        btn_sign_in_drawable.setStroke(1,AppController.getInstance().getSecondaryGrayColor());

        GradientDrawable serviceID_drawable = (GradientDrawable)userID_container.getBackground();
        serviceID_drawable.setColor(AppController.getInstance().getPrimaryGrayColor());

        GradientDrawable airline_drawable = (GradientDrawable)company_container.getBackground();
        airline_drawable.setColor(AppController.getInstance().getPrimaryGrayColor());

        GradientDrawable airport_code_drawable = (GradientDrawable)password_container.getBackground();
        airport_code_drawable.setColor(AppController.getInstance().getPrimaryGrayColor());

        view1.setBackgroundColor(AppController.getInstance().getSecondaryGrayColor());
        view2.setBackgroundColor(AppController.getInstance().getSecondaryGrayColor());
        view3.setBackgroundColor(AppController.getInstance().getSecondaryGrayColor());

        input_userId.setTextColor(AppController.getInstance().getPrimaryColor());
        input_userId.setHintTextColor(AppController.getInstance().getSecondaryGrayColor());

        input_companyId.setTextColor(AppController.getInstance().getPrimaryColor());
        input_companyId.setHintTextColor(AppController.getInstance().getSecondaryGrayColor());

        input_password.setTextColor(AppController.getInstance().getPrimaryColor());
        input_password.setHintTextColor(AppController.getInstance().getSecondaryGrayColor());

        customLoginDrawableBackground.getLinePaint().setColor(AppController.getInstance().getSecondaryGrayColor());

        if(isNightMode) {
            ColorMode.setText(getResources().getString(R.string.lightMode));
        } else {
            ColorMode.setText(getResources().getString(R.string.darkMode));
        }
        ScannerType.setAdapter(adapter);
        if(spinnerSelectedPosition != -1 && spinnerSelectedPosition <= adapter.getCount()) {
            ScannerType.setSelection(spinnerSelectedPosition);
        } else {
            ScannerType.setSelection(adapter.getPosition(getResources().getString(R.string.soft_scan)));
        }
        checkFieldsForEmptyValues();
    }

    @Override
    public void doLogin() {
        Preferences.getInstance().saveScannerType(this,ScannerItem);
        if (NetworkUtil.getConnectivityStatus(getApplicationContext()) != NetworkUtil.NETWORK_STATUS_NOT_CONNECTED) {
            final LoginRequest loginRequest = new LoginRequest(input_userId.getText().toString(), input_companyId.getText().toString(),
                    AppController.getInstance().sha256(input_password.getText().toString()));

            if(ScannerItem.equalsIgnoreCase(getResources().getString(R.string.socket_mobile_bt))) {
                Utils.checkPermission(this, PermissionRequester.STORAGE, new PermissionHandler() {
                    @Override
                    public void onGranted() {
                        ApiCalls.getInstance().login(loginRequest, LoginActivity.this);
                        progressbarContainer.setVisibility(View.VISIBLE);
                    }

                    @Override
                    public void onDenied() {
                    }
                });
            }else {
                ApiCalls.getInstance().login(loginRequest, LoginActivity.this);
                progressbarContainer.setVisibility(View.VISIBLE);
            }
        }else {
            ApiResponseDialog.getInstance().showDialog(getResources().getString(R.string.Network_Connection_Issue),false,false,true,Constants.ResponseDialogExpireTime,false);
        }
    }

    @Override
    public void onResponse(Call<LoginResponse> call, Response<LoginResponse> response) {
        loginresponse = null;
        Gson gson = new Gson();
        FragmentManager fragmentManager = getSupportFragmentManager();
        FragmentTransaction ft = fragmentManager.beginTransaction();

        if (response.body() != null) {
            loginresponse = response.body();
        } else {
            try {
                loginresponse = gson.fromJson(response.errorBody().string(), LoginResponse.class);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        //dummy data
//        String demo_file_data = AppController.getInstance().loadJSONFromAsset("demo_login_sample.txt");
//        loginresponse = gson.fromJson(demo_file_data, LoginResponse.class);

        if (loginresponse != null && loginresponse.isSuccess()) {
            String prefUsername = Preferences.getInstance().getUserID(getApplicationContext());
            if (prefUsername!=null && !prefUsername.equalsIgnoreCase(input_userId.getText().toString())) {
                List<BagTag> bagTagList = BagTagDBHelper.getInstance(getApplicationContext()).getBagtagTag().queryBuilder().where(BagTagDao.Properties.Synced.eq(false)).list();
                if (bagTagList != null && bagTagList.size() > 0) {
                    UnsyncedBagsDialog unsyncedBagsDialog = new UnsyncedBagsDialog();
                    unsyncedBagsDialog.setLoginReponse(LoginActivity.this, loginresponse);
                    unsyncedBagsDialog.show(ft, "unsyncedBagsDialog");
                    progressbarContainer.setVisibility(View.GONE);
                    return;
                }
            }
            whatToDoAfterSuccessfulLoginReponse(loginresponse);
        } else {
            if (loginresponse!=null && loginresponse.getErrors()!=null && loginresponse.getErrors().size()>0) {

                //show change password screeen
                if (loginresponse.getErrors().get(0).getError_code().equals("BJYAPLN005")) {

                    Preferences.getInstance().setUserID(getApplicationContext(), input_userId.getText().toString());
                    Preferences.getInstance().setCompanyID(getApplicationContext(), input_companyId.getText().toString());

                    Analytic.getInstance().sendScreen(R.string.EVENT_CHANGE_PASSWORD_SCREEN);

                    ChangepasswordFragment changepasswordFragment = new ChangepasswordFragment();
                    if (!changepasswordFragment.isAdded()) {
                        Bundle bundle = new Bundle();
                        bundle.putBoolean("showSubtitle",true);
                        changepasswordFragment.setArguments(bundle);
                        changepasswordFragment.show(ft, "changepasswordFragment");
                    }
                } else {
                    ApiResponseDialog.getInstance().showDialog(loginresponse.getErrors().get(0).getError_description(), false,false,true,Constants.ResponseDialogExpireTime,false);
                }
            }
        }
        progressbarContainer.setVisibility(View.GONE);
    }

    public void whatToDoAfterSuccessfulLoginReponse(LoginResponse loginresponse) {
        Gson gson = new Gson();
        if (loginresponse !=null && loginresponse.isSuccess()) {
            Preferences.getInstance().setLoginResponse(getApplicationContext(), gson.toJson(loginresponse));
            Preferences.getInstance().setServiceID(getApplicationContext(), loginresponse.getService_id());
            Preferences.getInstance().setUserID(getApplicationContext(), input_userId.getText().toString());
            Preferences.getInstance().setCompanyID(getApplicationContext(), input_companyId.getText().toString());
            Preferences.getInstance().deleteTrackingLocation(this);
            AlarmHelper.getInstance(getApplicationContext()).setAlarm(false);

            TrackingPointPresenter trackingPointPresenter = new TrackingPointPresenter(getApplicationContext());
            trackingPointPresenter.TrackingLoopCalls(null);

            //expiry in 7 days
            @SuppressLint("SimpleDateFormat") SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            Date password_expiryDate = null;
            if(loginresponse.getPassword_expiry_date()!=null) {
                try {
                    password_expiryDate = formatter.parse(loginresponse.getPassword_expiry_date());
                } catch (ParseException e) {
                    e.printStackTrace();
                }
                Calendar cal_max = Calendar.getInstance();
                cal_max.setTime(new Date());
                cal_max.add(Calendar.DAY_OF_YEAR, 7);

                Calendar expired_password = Calendar.getInstance();
                expired_password.setTime(password_expiryDate);

                Calendar cal_today = Calendar.getInstance();
                cal_today.set(Calendar.HOUR_OF_DAY, 0);
                cal_today.set(Calendar.MINUTE, 0);
                cal_today.set(Calendar.SECOND, 0);
                Date today = cal_today.getTime();
                int daysDifference ;
                if (password_expiryDate != null && password_expiryDate.compareTo(cal_max.getTime()) <= 0) {
                    if(password_expiryDate.before(new Date())) {
                        daysDifference = 0;
                    }else {
                        daysDifference = (int) ((password_expiryDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24))+1;
                    }
                    PasswordWarningDialog.getInstance(LoginActivity.this).showDialog(daysDifference, LoginActivity.this);
                }else {
                    setupAirportAirlineDialogs();
                }
            }else {
                setupAirportAirlineDialogs();
            }
        }
        progressbarContainer.setVisibility(View.GONE);
    }

    @Override
    public void onFailure(Call<LoginResponse> call, Throwable t) {
        progressbarContainer.setVisibility(View.GONE);
        ApiResponseDialog.getInstance().showDialog(getResources().getString(R.string.Network_Connection_Issue),false,false,true,Constants.ResponseDialogExpireTime,false);
    }

    private boolean appInstalledOrNot() {
        PackageManager pm = getPackageManager();
        try {
            pm.getPackageInfo("com.cognex.mxconnect", PackageManager.GET_ACTIVITIES);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void setupAirportAirlineDialogs() {
        if(loginresponse != null) {
            List<String> airportlist = AppController.getInstance().getAirportAirlineFromString(loginresponse.getAirports());
            List<String> airlinelist = AppController.getInstance().getAirportAirlineFromString(loginresponse.getAirlines());
        if (airportlist.size() == 1) {
            Preferences.getInstance().setAirportCode(getApplicationContext(), airportlist.get(0));

            if(airlinelist.size() == 1 ) {
                Preferences.getInstance().setAirlineCode(getApplicationContext(), airlinelist.get(0));
                if (ScannerItem != null && !ScannerItem.equalsIgnoreCase(" ")) {
                    if (ScannerItem.equalsIgnoreCase(getResources().getString(R.string.socket_mobile_bt))) {
                        Intent intent = new Intent(this, TestSocketScannerActivity.class);
                        startActivity(intent);
                    } else if (ScannerItem.equalsIgnoreCase(getResources().getString(R.string.cognex_scanner))) {
                        Intent intent = new Intent(this, TestCognexActivity.class);
                        startActivity(intent);
                    } else if(ScannerItem.equalsIgnoreCase(getResources().getString(R.string.soft_scan))){
                        Intent intent = new Intent(this, SoftScannerActivity.class);
                        startActivity(intent);
                    } else if(ScannerItem.equalsIgnoreCase(getResources().getString(R.string.honeywell_ct50_scanner))){
                        Intent intent = new Intent(this, HoneyWellScanner_Activity.class);
                        startActivity(intent);
                    }
                    finish();
                }
            } else {
                FragmentManager fragmentManager = getSupportFragmentManager();
                FragmentTransaction ft = fragmentManager.beginTransaction();
                SelectAirlineFragment selectAirlineFragment = new SelectAirlineFragment();
                if (!selectAirlineFragment.isAdded()) {
                    selectAirlineFragment.setType(true, null);
                    selectAirlineFragment.show(ft, "selectAirlineFragment");
                }
            }
        }
        //more than one airport
        else {
            FragmentManager fragmentManager = getSupportFragmentManager();
            FragmentTransaction ft = fragmentManager.beginTransaction();
            SelectAirportFragment selectAirportFragment = new SelectAirportFragment();
            if (!selectAirportFragment.isAdded()) {

                if(airlinelist.size() ==1){
                    Preferences.getInstance().setAirlineCode(getApplicationContext(), airlinelist.get(0));
                    selectAirportFragment.setType(true, null);
                }
                else
                    selectAirportFragment.setType(false, null);
                selectAirportFragment.show(ft, "selectAirportFragment");
            }
        }
    }
    }

}
