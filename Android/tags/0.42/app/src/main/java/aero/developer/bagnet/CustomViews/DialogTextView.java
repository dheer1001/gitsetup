package aero.developer.bagnet.CustomViews;

import android.content.Context;
import android.graphics.Typeface;
import android.util.AttributeSet;

/**
 * Created by User on 8/9/2016.
 */
public class DialogTextView extends android.support.v7.widget.AppCompatTextView {
    public DialogTextView(Context context) {
        super(context);
        init();
    }

    public DialogTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public DialogTextView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private void init(){
        if (!isInEditMode()){
            String fontPath = "fonts/SourceSansPro-Regular.otf";
            Typeface tf = Typeface.createFromAsset(getContext().getAssets(), fontPath);
            setTypeface(tf);
        }
    }
}
