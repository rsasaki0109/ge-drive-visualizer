find_package(GTest QUIET)

if(GTest_FOUND)
    add_executable(test_kml test_kml.cpp)
    target_link_libraries(test_kml PRIVATE gnss_kml_lib GTest::gtest GTest::gtest_main)
    add_test(NAME KmlTests COMMAND test_kml)
else()
    # Standalone test without GTest
    add_executable(test_kml_standalone test_kml_standalone.cpp)
    target_link_libraries(test_kml_standalone PRIVATE gnss_kml_lib)
    add_test(NAME KmlStandaloneTests COMMAND test_kml_standalone)
endif()
