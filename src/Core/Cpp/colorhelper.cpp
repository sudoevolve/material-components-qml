#include "colorhelper.h"
#include "cam/hct.h"

using namespace material_color_utilities;

double ColorHelper::hue(const QColor &color) const
{
    return Hct{color.rgb()}.get_hue();
}

double ColorHelper::chroma(const QColor &color) const
{
    return Hct{color.rgb()}.get_chroma();
}

double ColorHelper::tone(const QColor &color) const
{
    return Hct{color.rgb()}.get_tone();
}

QString ColorHelper::ahex(const QColor &color) const 
{
    return color.name(QColor::HexArgb).toUpper();
}

QString ColorHelper::hex(const QColor &color) const 
{
    return color.name(QColor::HexRgb).toUpper();
}

QColor ColorHelper::hct2QColor(double hue, double chroma, double tone) const
{
    return QColor{Hct{hue, chroma, tone}.ToInt()};
}
