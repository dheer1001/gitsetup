package aero.developer.bagnet.dialogs;

import android.app.Dialog;
import android.app.DialogFragment;
import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.support.v7.app.AppCompatActivity;
import android.view.Window;
import android.widget.RelativeLayout;
import android.widget.TextView;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.R;
import aero.developer.bagnet.scantypes.EngineActivity;
import aero.developer.bagnet.utils.Preferences;

/**
 * Created by User on 01-Mar-18.
 */

public class FetchingBagDialog extends DialogFragment {

    private static FetchingBagDialog instance;
    private static Dialog dialog = null;
    private static Context _context;

    public static FetchingBagDialog getInstance(Context context) {
        _context = EngineActivity.engineActivity;
            instance=new FetchingBagDialog();
            dialog = new Dialog(_context);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        return instance;
    }

    public FetchingBagDialog() {}

    public void showDialog() {
        if (!((AppCompatActivity) _context).isFinishing()) {
            dialog.setCancelable(false);
            dialog.setContentView(R.layout.fetching_bag_dialog);

            RelativeLayout main_container = (RelativeLayout) dialog.findViewById(R.id.main_container);
            TextView fetching_bag = (TextView) dialog.findViewById(R.id.fetching_bag);

            //adjust Colors
            GradientDrawable gradientdrawable = (GradientDrawable) main_container.getBackground();
            gradientdrawable.setColor(AppController.getInstance().getPrimaryGrayColor());

            if(Preferences.getInstance().isNightMode(_context)) {
                gradientdrawable.setStroke(4, AppController.getInstance().getPrimaryColor());
            }else {
                gradientdrawable.setStroke(4, AppController.getInstance().getSecondaryGrayColor());
            }
            fetching_bag.setTextColor(AppController.getInstance().getPrimaryColor());

            try{
                dialog.show();
            }catch (Exception e){
                e.printStackTrace();
            }
        }
    }

    public static void hideDialog() {
        if(dialog!=null && dialog.isShowing()){
            dialog.dismiss();
            dialog = null;
            instance = null;
            _context = null;
        }
    }

    public static boolean isShown(){
        boolean shown=false;
        if(dialog!=null && dialog.isShowing()){
            shown=true;
        }
        return shown;
    }
}
