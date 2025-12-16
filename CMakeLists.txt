cmake_minimum_required(VERSION 3.16)

project(Chronometris VERSION 1.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick Sql QuickControls2 QuickDialogs2 Multimedia REQUIRED)

qt_standard_project_setup()

# Add the C++ files
qt_add_executable(appChronometris
    main.cpp
    src/DatabaseManager.cpp src/DatabaseManager.h
    src/TimerEngine.cpp src/TimerEngine.h
)

# Add the QML files and Assets
qt_add_qml_module(appChronometris
    URI Chronometris
    VERSION 1.0.0
    QML_FILES
        Main.qml

        components/RoundButton.qml
        components/ThemeManager.qml
        components/TimerProgressCircle.qml
        components/ColoredIcon.qml
        components/TimePicker.qml
        components/ColoredIcon.qml
        components/TimePIcker.qml
        components/DatePicker.qml

        pages/AlarmsPage.qml
        pages/AnalyticsPage.qml
        pages/DashboardPage.qml
        pages/TimerPage.qml

        overlays/AboutOverlay.qml
        overlays/AddAlarmOverlay.qml
        overlays/AddTimerOverlay.qml
        overlays/DetailsOverlay.qml

    RESOURCES
        assets/icons/account.svg
        assets/icons/add.svg
        assets/icons/add_alarm.svg
        assets/icons/alarm.svg
        assets/icons/analytics.svg
        assets/icons/arrow_drop_down.svg
        assets/icons/check.svg
        assets/icons/close.svg
        assets/icons/dashboard.svg
        assets/icons/delete.svg
        assets/icons/edit.svg
        assets/icons/fast_forward.svg
        assets/icons/fiber_manual_record.svg
        assets/icons/hourglass_bottom.svg
        assets/icons/pause.svg
        assets/icons/play_arrow.svg
        assets/icons/radio_button_checked.svg
        assets/icons/radio_button_unchecked.svg
        assets/icons/settings.svg
        assets/icons/skip_next.svg
        assets/icons/stop.svg
        assets/icons/timer.svg

        assets/logo/Logo.png
)

target_link_libraries(appChronometris PRIVATE Qt6::Quick Qt6::Sql Qt6::QuickControls2 Qt6::QuickDialogs2 Qt6::Multimedia)
