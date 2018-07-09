package aero.developer.bagnet.CustomViews;

import android.content.Context;
import android.graphics.Typeface;
import android.util.AttributeSet;

/**
 * Created by User on 8/9/2016.
 */
public class HeaderTextView extends android.support.v7.widget.AppCompatTextView {
    public HeaderTextView(Context context) {
        super(context);
        init();
    }

    public HeaderTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public HeaderTextView(Context context, AttributeSet attrs, int defStyleAttr) {
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
