#include "stylemanager.h"
#include <QDebug>
#include <QQmlFile>
#include <QImageReader>

// Material Color Utilities headers
#include "scheme/scheme_tonal_spot.h"
#include "quantize/celebi.h"
#include "score/score.h"
#include "blend/blend.h"

using namespace material_color_utilities;

StyleManager::StyleManager(QObject *parent)
    : QObject(parent)
    , m_isDarkTheme(false)
    , m_seedColor(QColor("#6750a4")) // Default MD3 seed
{
    updateScheme();
}

bool StyleManager::isDarkTheme() const
{
    return m_isDarkTheme;
}

void StyleManager::setIsDarkTheme(bool isDark)
{
    if (m_isDarkTheme == isDark)
        return;

    m_isDarkTheme = isDark;
    emit isDarkThemeChanged();
    updateScheme();
}

QColor StyleManager::seedColor() const
{
    return m_seedColor;
}

void StyleManager::setSeedColor(const QColor &color)
{
    if (m_seedColor == color)
        return;

    m_seedColor = color;
    emit seedColorChanged();
    updateScheme();
}

QVariantMap StyleManager::currentScheme() const
{
    return m_currentScheme;
}

QVariantMap StyleManager::lightScheme() const
{
    return m_lightScheme;
}

QVariantMap StyleManager::darkScheme() const
{
    return m_darkScheme;
}

void StyleManager::setSourceImage(const QUrl &fileUrl)
{
    QString localFile = QQmlFile::urlToLocalFileOrQrc(fileUrl);
    QImage image(localFile);
    if (image.isNull()) {
        qWarning() << "Failed to load image from:" << localFile;
        return;
    }

    // Scale down for performance
    if (image.width() > 128 || image.height() > 128) {
        image = image.scaled(128, 128, Qt::KeepAspectRatio);
    }
    
    image = image.convertToFormat(QImage::Format_ARGB32);

    std::vector<Argb> pixels;
    pixels.reserve(image.width() * image.height());

    for (int y = 0; y < image.height(); ++y) {
        const QRgb *line = reinterpret_cast<const QRgb *>(image.constScanLine(y));
        for (int x = 0; x < image.width(); ++x) {
            pixels.push_back(line[x]);
        }
    }

    // Quantize and Score
    QuantizerResult result = QuantizeCelebi(pixels, 128);
    std::map<Argb, uint32_t> argb_to_population;
    for (auto const& [color, count] : result.color_to_count) {
        argb_to_population[color] = count;
    }
    std::vector<uint32_t> ranked = RankedSuggestions(argb_to_population);

    if (!ranked.empty()) {
        QColor bestColor(ranked[0]);
        setSeedColor(bestColor);
    }
}

void StyleManager::updateScheme()
{
    uint32_t argb = m_seedColor.rgba();
    
    // Always generate both schemes
    m_lightScheme = generateScheme(argb, false);
    m_darkScheme = generateScheme(argb, true);
    
    // Determine current scheme based on isDarkTheme
    m_currentScheme = m_isDarkTheme ? m_darkScheme : m_lightScheme;
    
    emit lightSchemeChanged();
    emit darkSchemeChanged();
    emit currentSchemeChanged();
}

static QString toHex(Argb argb) {
    return QColor(argb).name(QColor::HexArgb);
}

QVariantMap StyleManager::generateScheme(uint32_t argb, bool isDark)
{
    SchemeTonalSpot scheme(Hct(argb), isDark, 0.0);
    QVariantMap map;

    map["primary"] = toHex(scheme.GetPrimary());
    map["onPrimaryColor"] = toHex(scheme.GetOnPrimary());
    map["primaryContainer"] = toHex(scheme.GetPrimaryContainer());
    map["onPrimaryContainerColor"] = toHex(scheme.GetOnPrimaryContainer());
    map["secondary"] = toHex(scheme.GetSecondary());
    map["onSecondaryColor"] = toHex(scheme.GetOnSecondary());
    map["secondaryContainer"] = toHex(scheme.GetSecondaryContainer());
    map["onSecondaryContainerColor"] = toHex(scheme.GetOnSecondaryContainer());
    map["tertiary"] = toHex(scheme.GetTertiary());
    map["onTertiaryColor"] = toHex(scheme.GetOnTertiary());
    map["tertiaryContainer"] = toHex(scheme.GetTertiaryContainer());
    map["onTertiaryContainerColor"] = toHex(scheme.GetOnTertiaryContainer());
    map["error"] = toHex(scheme.GetError());
    map["onErrorColor"] = toHex(scheme.GetOnError());
    map["errorContainer"] = toHex(scheme.GetErrorContainer());
    map["onErrorContainerColor"] = toHex(scheme.GetOnErrorContainer());
    map["background"] = toHex(scheme.GetBackground());
    map["onBackgroundColor"] = toHex(scheme.GetOnBackground());
    map["surface"] = toHex(scheme.GetSurface());
    map["onSurfaceColor"] = toHex(scheme.GetOnSurface());
    map["surfaceVariant"] = toHex(scheme.GetSurfaceVariant());
    map["onSurfaceVariantColor"] = toHex(scheme.GetOnSurfaceVariant());
    map["outline"] = toHex(scheme.GetOutline());
    map["outlineVariant"] = toHex(scheme.GetOutlineVariant());
    map["shadow"] = toHex(scheme.GetShadow());
    map["scrim"] = toHex(scheme.GetScrim());
    map["inverseSurface"] = toHex(scheme.GetInverseSurface());
    map["inverseOnSurface"] = toHex(scheme.GetInverseOnSurface());
    map["inversePrimary"] = toHex(scheme.GetInversePrimary());
    map["surfaceDim"] = toHex(scheme.GetSurfaceDim());
    map["surfaceBright"] = toHex(scheme.GetSurfaceBright());
    map["surfaceContainerLowest"] = toHex(scheme.GetSurfaceContainerLowest());
    map["surfaceContainerLow"] = toHex(scheme.GetSurfaceContainerLow());
    map["surfaceContainer"] = toHex(scheme.GetSurfaceContainer());
    map["surfaceContainerHigh"] = toHex(scheme.GetSurfaceContainerHigh());
    map["surfaceContainerHighest"] = toHex(scheme.GetSurfaceContainerHighest());
    
    return map;
}
