package aero.developer.bagnet.CustomViews;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.os.Build;
import android.support.annotation.RequiresApi;
import android.util.AttributeSet;
import android.view.View;

import aero.developer.bagnet.AppController;

/**
 * Created by User on 10-Oct-17.
 */

public class CustomLoginDrawableBackground extends View {
    private Paint linePaint = new Paint();

    public CustomLoginDrawableBackground(Context context) {
        super(context);
        init();
    }

    public CustomLoginDrawableBackground(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public CustomLoginDrawableBackground(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public CustomLoginDrawableBackground(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        init();
    }

    public Paint getLinePaint(){
        return this.linePaint;
    }

    public void init()
    {
        linePaint.setColor(AppController.getInstance().getPrimaryColor());
        linePaint.setStyle(Paint.Style.STROKE);
        linePaint.setAntiAlias(true);
        linePaint.setStrokeWidth(3);
    }
    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        Path path = new Path();

        int h = getMeasuredHeight();
        int w = getMeasuredWidth();

        int viewHeight = h/13;
        int value = w/2 - w/9;
        int space = w/10;

        path.moveTo(0, getMeasuredHeight() - viewHeight);
        path.lineTo(value, getMeasuredHeight() - viewHeight);
//        path.rQuadTo(w/2-35,viewHeight,w/2-40,viewHeight);
        path.lineTo(value + space, getMeasuredHeight());

        path.moveTo(value + space + w/26, getMeasuredHeight() );
        path.lineTo(value + space + w/26 + space, getMeasuredHeight() - viewHeight);
        path.lineTo(getMeasuredWidth(), getMeasuredHeight() - viewHeight);

        canvas.drawPath(path, linePaint);
    }
}
