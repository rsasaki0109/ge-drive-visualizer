/**
 * @file test_kml_standalone.cpp
 * @brief Standalone tests (no GTest dependency) - generates test KML files.
 */

#include <libgnss++/kml/kml.hpp>

#include <iostream>
#include <cassert>
#include <cmath>
#include <string>

using namespace libgnss::kml;

int main() {
    int passed = 0;
    int total = 0;

    auto check = [&](bool cond, const char* name) {
        total++;
        if (cond) {
            passed++;
            std::cout << "  PASS: " << name << std::endl;
        } else {
            std::cerr << "  FAIL: " << name << std::endl;
        }
    };

    // --- Utils ---
    std::cout << "[Utils]" << std::endl;
    check(col2hex(Color(1, 0, 0), 1.0) == "FF0000FF", "col2hex red");
    check(col2hex(Color(0, 0, 1), 1.0) == "FFFF0000", "col2hex blue");
    check(wrapTo720(0.0) == 0.0, "wrapTo720(0)");
    check(wrapTo720(720.0) == 0.0, "wrapTo720(720)");

    auto unwrapped = unwrap360({350, 355, 0, 5});
    check(unwrapped[2] > 355.0, "unwrap360 continuity");

    auto loc = enu2llh(0, 0, 0, 35.0, 139.0, 50.0);
    check(std::abs(loc.lat - 35.0) < 1e-8, "enu2llh zero offset");

    auto cv = calcCubeVertices(Location(35.0, 139.0, 10.0), 1.0);
    check(cv.faces.size() == 5, "calcCubeVertices 5 faces");

    // --- Elements ---
    std::cout << "[Elements]" << std::endl;
    auto kml_line = createLine("L", {{35, 139, 0}, {35.001, 139.001, 0}}, 3, Color(1, 0, 0));
    check(kml_line.find("<LineString>") != std::string::npos, "createLine");

    auto kml_model = createModel("V", "car.dae", {35, 139, 0}, {90, 0, 0});
    check(kml_model.find("VLoc") != std::string::npos, "createModel");

    // --- Camera ---
    std::cout << "[Camera]" << std::endl;
    auto look = createLookAt({35, 139, 0}, LookAtParams(0, 50, 90));
    check(look.find("<LookAt>") != std::string::npos, "createLookAt");

    auto cam = createCamera({35, 139, 100}, CameraParams(0, 35, 0), AltitudeMode::Absolute);
    check(cam.find("<Camera>") != std::string::npos, "createCamera");

    // --- Tour ---
    std::cout << "[Tour]" << std::endl;
    auto tour = wrapTour(createWait(1.0), "Test");
    check(tour.find("<gx:Tour>") != std::string::npos, "wrapTour");

    auto flyto = wrapFlyTo(look, 1.0);
    check(flyto.find("<gx:FlyTo>") != std::string::npos, "wrapFlyTo");

    // --- Animation ---
    std::cout << "[Animation]" << std::endl;
    auto anim = animatedUpdateModel("V", 0.2, {35.001, 139.001, 0}, Orientation(30, 0, 0));
    check(anim.find("VLoc") != std::string::npos, "animatedUpdateModel");

    // --- Writer ---
    std::cout << "[Writer]" << std::endl;
    check(writeKml("/tmp/test_standalone.kml", look, "Test"), "writeKml");
    std::remove("/tmp/test_standalone.kml");

    // --- Generate full test KML (AnimatedUpdateModel) ---
    std::cout << "[Integration]" << std::endl;
    {
        Location loc1(35.68777685, 140.019451842, 0);
        Location loc2(35.68790685, 140.019451842, 0);
        Orientation ori1(0, 0, 0);
        Orientation ori2(30, 0, 0);
        LookAtParams cam_params(0, 50, 30);

        auto kml_look0 = createLookAt(loc1, cam_params);
        auto kml_mdl = createModel("Vehicle", "model/vehicle_gray.dae", loc1, ori1);

        std::string tour_content;
        tour_content += wrapFlyTo(kml_look0);
        tour_content += animatedUpdateModel("Vehicle", 1.0, loc2, ori2);
        tour_content += wrapFlyTo(createLookAt(loc2, cam_params), 1.0);
        auto kml_tour = wrapTour(tour_content, "DriveTour");

        bool ok = writeKml("/tmp/test_animated_model.kml",
                           kml_look0 + kml_mdl + kml_tour);
        check(ok, "full integration KML");
        std::remove("/tmp/test_animated_model.kml");
    }

    std::cout << "\nResults: " << passed << "/" << total << " passed" << std::endl;
    return (passed == total) ? 0 : 1;
}
