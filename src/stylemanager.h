#ifndef STYLEMANAGER_H
#define STYLEMANAGER_H

#include <QObject>
#include <QColor>
#include <QImage>
#include <QMap>
#include <QVariantMap>
#include <QtQml/qqml.h>

class StyleManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(bool isDarkTheme READ isDarkTheme WRITE setIsDarkTheme NOTIFY isDarkThemeChanged)
    Q_PROPERTY(QColor seedColor READ seedColor WRITE setSeedColor NOTIFY seedColorChanged)
    Q_PROPERTY(double hctHue READ hctHue NOTIFY seedColorChanged)
    Q_PROPERTY(double hctChroma READ hctChroma NOTIFY seedColorChanged)
    Q_PROPERTY(double hctTone READ hctTone NOTIFY seedColorChanged)
    Q_PROPERTY(QVariantMap currentScheme READ currentScheme NOTIFY currentSchemeChanged)
    Q_PROPERTY(QVariantMap lightScheme READ lightScheme NOTIFY lightSchemeChanged)
    Q_PROPERTY(QVariantMap darkScheme READ darkScheme NOTIFY darkSchemeChanged)

public:
    explicit StyleManager(QObject *parent = nullptr);

    bool isDarkTheme() const;
    void setIsDarkTheme(bool isDark);

    QColor seedColor() const;
    void setSeedColor(const QColor &color);

    double hctHue() const;
    double hctChroma() const;
    double hctTone() const;

    QVariantMap currentScheme() const;
    QVariantMap lightScheme() const;
    QVariantMap darkScheme() const;

    Q_INVOKABLE void setSeedColorHct(double hue, double chroma, double tone);
    Q_INVOKABLE void setSourceImage(const QUrl &fileUrl);

signals:
    void isDarkThemeChanged();
    void seedColorChanged();
    void currentSchemeChanged();
    void lightSchemeChanged();
    void darkSchemeChanged();

private:
    void updateScheme();
    QVariantMap generateScheme(uint32_t argb, bool isDark);

    bool m_isDarkTheme;
    QColor m_seedColor;
    QVariantMap m_currentScheme;
    QVariantMap m_lightScheme;
    QVariantMap m_darkScheme;
};

#endif // STYLEMANAGER_H
