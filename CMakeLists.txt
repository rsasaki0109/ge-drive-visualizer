cmake_minimum_required(VERSION 3.15)
project(ge_drive_visualizer VERSION 1.0.0 LANGUAGES CXX)

# C++17 standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Build options
option(BUILD_EXAMPLES "Build example programs" ON)
option(BUILD_TESTS "Build unit tests" ON)

# Compiler flags
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    add_compile_options(-Wall -Wextra -O2)
endif()

# ============================================================
# Library: gnss_kml_lib
# ============================================================
set(KML_SOURCES
    src/kml/types.cpp
    src/kml/utils.cpp
    src/kml/elements.cpp
    src/kml/animation.cpp
    src/kml/camera.cpp
    src/kml/tour.cpp
    src/kml/writer.cpp
)

add_library(gnss_kml_lib STATIC ${KML_SOURCES})

target_include_directories(gnss_kml_lib PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)
target_compile_features(gnss_kml_lib PUBLIC cxx_std_17)

# ============================================================
# Examples
# ============================================================
if(BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()

# ============================================================
# Tests
# ============================================================
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

# ============================================================
# Installation
# ============================================================
install(TARGETS gnss_kml_lib
    EXPORT gnss_kml_libTargets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include
)

install(DIRECTORY include/ DESTINATION include)

install(EXPORT gnss_kml_libTargets
    FILE gnss_kml_libTargets.cmake
    NAMESPACE libgnss++::
    DESTINATION lib/cmake/gnss_kml_lib
)

# ============================================================
# ament (ROS 2) support - optional
# ============================================================
find_package(ament_cmake QUIET)
if(ament_cmake_FOUND)
    ament_export_targets(gnss_kml_libTargets HAS_LIBRARY_TARGET)
    ament_export_include_directories(include)
    ament_package()
endif()
