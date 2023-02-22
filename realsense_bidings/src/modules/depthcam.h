// License: Apache 2.0. See LICENSE file in root directory.
// Copyright(c) 2017 Intel Corporation. All Rights Reserved.

#include <librealsense2/rs.hpp> // Include RealSense Cross Platform API
#include <fstream>              // File IO
#include <iostream>             // Terminal IO
#include <sstream>              // Stringstreams
#include <opencv2/opencv.hpp>   // Include OpenCV API

class DepthCam
{

public:
    // Declare depth colorizer for pretty visualization of depth data
    rs2::colorizer   color_map;
    rs2::pipeline    pipe;
    rs2::frameset    data;

    rs2::frame       frame_depth;
    rs2::frame       frame_color;

    cv::Mat          frame;
    cv::Mat          depth_frame;
    
    DepthCam()
    {

        //rs2::log_to_console(RS2_LOG_SEVERITY_ERROR);

        rs2::rates_printer printer;
        pipe.start();

        //std::cout << "pipe started"<<std::endl;
        //color_map.set_option(RS2_OPTION_HISTOGRAM_EQUALIZATION_ENABLED, 1.f);
        color_map.set_option(RS2_OPTION_COLOR_SCHEME, 2.f); // White to Black

    }

    void getFrame()
    {

        data         = pipe.wait_for_frames();
        
        frame_depth  = data.get_depth_frame().apply_filter(color_map);;
        frame_color  = data.get_color_frame();

        auto vf_depth = frame_depth.as<rs2::video_frame>();
        auto vf_color = frame_color.as<rs2::video_frame>();
        
        const int w = vf_depth.as<rs2::video_frame>().get_width();
        const int h = vf_depth.as<rs2::video_frame>().get_height();

        const int w2 = vf_color.as<rs2::video_frame>().get_width();
        const int h2 = vf_color.as<rs2::video_frame>().get_height();

        cv::Mat image_depth(cv::Size(w, h),   CV_8UC3, (void*)vf_depth.get_data(), cv::Mat::AUTO_STEP);
        cv::Mat image_color(cv::Size(w2, h2), CV_8UC3, (void*)vf_color.get_data(), cv::Mat::AUTO_STEP);

        cv::cvtColor(image_color, image_color, cv::COLOR_RGB2BGR);

        int offset_x = 18;
        int offset_y = 20;

        cv::Rect myROI_Color(int(offset_x),int(offset_y),int(1280-offset_x),int(720-offset_y));
        cv::Rect myROI_Depth(0,0,int(1280-offset_x),int(720-offset_y));

        image_depth = image_depth(myROI_Depth);
        image_color = image_color(myROI_Color);

        cv::Rect myROI(int(1280/2-100),int(720/2-100),int(200),int(200));

        frame       = image_color;
        depth_frame = image_depth;        
    }

    int getDepth( int x, int y)
    {
        auto as_depth = data.get_depth_frame().as<rs2::depth_frame>();
        auto value    = as_depth.get_distance(x,y);

        //std::cout << "distance: " << value*1000<<" mm" <<std::endl;
        int milimiters = value*1000;

        return milimiters;

    }

    
    float getDist3D(int xi, int yi, int xf, int yf)
    {
        auto const intr = pipe.get_active_profile().get_stream(RS2_STREAM_DEPTH).as<rs2::video_stream_profile>().get_intrinsics();
        
        float upixel[2]; // From pixel
        float upoint[3]; // From point (in 3D)

        float vpixel[2]; // To pixel
        float vpoint[3]; // To point (in 3D)

        upixel[0] = float(xi);
        upixel[1] = float(yi);
        vpixel[0] = float(xf);
        vpixel[1] = float(yf);

        // Query the frame for distance
        // Note: this can be optimized
        // It is not recommended to issue an API call for each pixel
        // (since the compiler can't inline these)
        // However, in this example it is not one of the bottlenecks

        auto frame = data.get_depth_frame().as<rs2::depth_frame>();
        auto udist = frame.get_distance(upixel[0], upixel[1]);
        auto vdist = frame.get_distance(vpixel[0], vpixel[1]);

        // Deproject from pixel to point in 3D
        rs2_deproject_pixel_to_point(upoint, &intr, upixel, udist);
        rs2_deproject_pixel_to_point(vpoint, &intr, vpixel, vdist);

        // Calculate euclidean distance between the two points
        return sqrt(pow(upoint[0] - vpoint[0], 2) +
                    pow(upoint[1] - vpoint[1], 2) +
                    pow(upoint[2] - vpoint[2], 2));
    }

     
    void show()
    {
        cv::imshow("OpenCV - DNN Face Detection", frame);

        int k = cv::waitKey(5);

        if(k == 27)
        {
            cv::destroyAllWindows();
            exit (EXIT_FAILURE);
        }
    }

    ~DepthCam()
    {
        pipe.stop();
    }
};





