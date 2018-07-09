package aero.developer.bagnet.CustomViews;

import android.content.Context;
import android.graphics.Typeface;
import android.support.v7.widget.AppCompatEditText;
import android.util.AttributeSet;

/**
 * Created by User on 8/26/2016.
 */
public class CostumEditText extends AppCompatEditText {
    public CostumEditText(Context context) {
        super(context);
        init();
    }

    public CostumEditText(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public CostumEditText(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private void init(){
        if (!isInEditMode()){
            String fontPath = "fonts/SourceSansPro-Semibold.otf";
            Typeface tf = Typeface.createFromAsset(getContext().getAssets(), fontPath);
            setTypeface(tf);
        }
    }
}
