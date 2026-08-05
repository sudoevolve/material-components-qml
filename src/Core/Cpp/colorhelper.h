#ifndef COLORHELPER_H
#define COLORHELPER_H

#include <QColor>
#include <QObject>
#include <QString>
#include <QtQml/qqml.h>

class ColorHelper : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    Q_INVOKABLE double  hue(const QColor &color) const;
    Q_INVOKABLE double  chroma(const QColor &color) const;
    Q_INVOKABLE double  tone(const QColor &color) const;
    Q_INVOKABLE QString ahex(const QColor &color) const; // Returns "#AARRGGBB"
    Q_INVOKABLE QString hex(const QColor &color) const;  // Returns "#RRGGBB"
    Q_INVOKABLE QColor  hct2QColor(double hue, double chroma, double tone) const;
};

#endif
