package aero.developer.bagnet.CustomViews;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.support.v7.widget.AppCompatTextView;
import android.text.Layout;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.util.TypedValue;

import aero.developer.bagnet.R;


public class SingleLine_AutoResizeTextView extends AppCompatTextView {
    float defaultTextSize = 0.0f;

    public SingleLine_AutoResizeTextView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        defaultTextSize = getTextSize();
    }

    public SingleLine_AutoResizeTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        defaultTextSize = getTextSize();
        @SuppressLint({"Recycle", "CustomViewStyleable"}) TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.AutoresizeTextView);

        if (ta != null) {
            String fontPath = ta.getString(R.styleable.AutoresizeTextView_typefaceAsset);

            if (!TextUtils.isEmpty(fontPath)) {
                Typeface tf = Typeface.createFromAsset(getContext().getAssets(), fontPath);
                int style = Typeface.NORMAL;

                if (getTypeface() != null)
                    style = getTypeface().getStyle();

                if (tf != null)
                    setTypeface(tf, style);
            }
        }
    }

    public SingleLine_AutoResizeTextView(Context context) {
        super(context);
        defaultTextSize = getTextSize();
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        setTextSize(TypedValue.COMPLEX_UNIT_PX, defaultTextSize);
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        final Layout layout = getLayout();
        if (layout != null) {
            final int lineCount = layout.getLineCount();
            if (lineCount > 0) {
                int ellipsisCount = layout.getEllipsisCount(lineCount - 1);
                while (ellipsisCount > 0) {
                    final float textSize = getTextSize();

                    // textSize is already expressed in pixels
                    setTextSize(TypedValue.COMPLEX_UNIT_PX, (textSize - 1));
                    super.onMeasure(widthMeasureSpec, heightMeasureSpec);
                    ellipsisCount = layout.getEllipsisCount(lineCount - 1);
                }
            }
        }
    }
}