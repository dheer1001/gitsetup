package aero.developer.bagnet.CustomViews;

import android.content.Context;
import android.graphics.Typeface;
import android.util.AttributeSet;

/**
 * Created by User on 8/9/2016.
 */
public class DigitalTextView extends android.support.v7.widget.AppCompatTextView {
    public DigitalTextView(Context context) {
        super(context);
        init();
    }

    public DigitalTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public DigitalTextView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private void init() {
        if (!isInEditMode()) {
            String fontPath = "fonts/ufonts.com_ds-digital.ttf";
            Typeface tf = Typeface.createFromAsset(getContext().getAssets(), fontPath);
            setTypeface(tf);
        }
    }
}
