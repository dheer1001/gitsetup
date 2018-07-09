package aero.developer.bagnet.dialogs;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.squareup.picasso.Picasso;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.Constants;
import aero.developer.bagnet.CustomViews.HeaderTextView;
import aero.developer.bagnet.R;
import aero.developer.bagnet.utils.DataManUtils;
import aero.developer.bagnet.utils.Preferences;
import aero.developer.bagnet.utils.ULD_Utils;

import static aero.developer.bagnet.scantypes.EngineActivity.engineActivity;

/**
 * Created by User on 24-Oct-17.
 */

public class IdentifiedContainerDialog extends DialogFragment {
    @SuppressLint("StaticFieldLeak")
    public static IdentifiedContainerDialog instance;
    @SuppressLint("StaticFieldLeak")
    private static Context _context;
    private static Dialog dialog = null;

    public static IdentifiedContainerDialog getInstance(Context context) {
        _context = context;
        if(instance==null){
            instance=new IdentifiedContainerDialog();
        }
        if (dialog==null){
            dialog = new Dialog(_context);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        }
        return instance;
    }

    public void showDialog(final boolean isBottomAligned) {
        if (!((AppCompatActivity) _context).isFinishing()) {
            try {
                dialog.setCancelable(false);
                engineActivity.floatingActionButton.setVisibility(View.GONE);
                engineActivity.scanPromptView.hideView();

                dialog.setContentView(R.layout.identified_container_dialog);
                ImageView imgContainer = (ImageView) dialog.findViewById(R.id.imgContainer);
                HeaderTextView txt_title = (HeaderTextView) dialog.findViewById(R.id.txt_title);
                HeaderTextView txt_containerId = (HeaderTextView) dialog.findViewById(R.id.txt_containerId);
                RelativeLayout main_container = (RelativeLayout) dialog.findViewById(R.id.main_container);

                if (Preferences.getInstance().getContaineruld(_context) != null) {
                    txt_containerId.setText(Preferences.getInstance().getContaineruld(_context));
                }

                String containerUld = Preferences.getInstance().getContaineruld(_context).toUpperCase();
                String Uldtype= ULD_Utils.getContainerTypeChar(ULD_Utils.getULDType(containerUld));
                if(!containerUld.equals("") && DataManUtils.isValidContainer(containerUld)) {
                    Picasso.with(_context).load(ULD_Utils.getImage(Uldtype)).into(imgContainer);
                }

                //adjust colors
                boolean isNightMode = Preferences.getInstance().isNightMode(_context);
                if (isNightMode) {
                    txt_containerId.setTextColor(AppController.getInstance().getPrimaryColor());
                    txt_title.setTextColor(AppController.getInstance().getPrimaryColor());
                    GradientDrawable gradientdrawable = (GradientDrawable) main_container.getBackground();
                    gradientdrawable.setColor(AppController.getInstance().getPrimaryGrayColor());
                    gradientdrawable.setStroke(4, AppController.getInstance().getPrimaryColor());
                }

                WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
                Window window = dialog.getWindow();
                if(window!=null) {
                    lp.copyFrom(window.getAttributes());
                    lp.width = WindowManager.LayoutParams.MATCH_PARENT;
                    window.setAttributes(lp);
                }

                dialog.show();

                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        hideDialog();
                        engineActivity.floatingActionButton.setVisibility(View.VISIBLE);
                        engineActivity.scanPromptView.setPromptForBags();
                    }
                }, Constants.ResponseDialogExpireTime);
            } catch (Exception e) {
                e.printStackTrace();
                hideDialog();
                engineActivity.floatingActionButton.setVisibility(View.VISIBLE);
                engineActivity.scanPromptView.setPromptForBags();
            }
        } else {
            hideDialog();
            engineActivity.floatingActionButton.setVisibility(View.VISIBLE);
            engineActivity.scanPromptView.setPromptForBags();
        }
    }

    public static void hideDialog() {
        if(dialog!=null && dialog.isShowing()){
            dialog.dismiss();
        }
        dialog = null;
        instance = null;
    }

    public boolean isShown() {
        return dialog != null && dialog.isShowing();
    }


}
