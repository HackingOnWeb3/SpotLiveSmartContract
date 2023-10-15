// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library DistanceCalculator {

    int256 private constant R = 6371000; // Earth radius in meters

    // Function to calculate distance between two coordinates using Haversine formula
    function calculateDistance(
        int256 lat1,
        int256 lon1,
        int256 lat2,
        int256 lon2
    ) internal pure returns (int256) {

        int256 dlat = toRadians(lat2 - lat1) / 1000000;
        int256 dlon = toRadians(lon2 - lon1) / 1000000;
        
        int256 a = (sinSquared(dlat / 2) + (cosine(lat1) * cosine(lat2) * sinSquared(dlon / 2))) / (1000 * 1000);
        int256 c = 2 * arcsine(sqrt(a));

        // Distance in meters
        return R * c;
    }

    function toRadians(int256 degree) private pure returns (int256) {
        return (degree * 3141592) / 180000000; // Approximation of pi = 3.141592
    }

    function cosine(int256 degree) private pure returns (int256) {
        return (cosineApprox(degree * 1000));
    }
    
    function sinSquared(int256 x) private pure returns (int256) {
        return ((x * x) / (1000 * 1000));
    }

    function arcsine(int256 x) private pure returns (int256) {
        return (x * 1000); 
    }

    function sqrt(int256 x) private pure returns (int256) {
        int256 z = (x + 1) / 2;
        int256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }
    
    function cosineApprox(int256 x) private pure returns (int256) {
        // We will use a polynomial approximation for cosine
        int256 a0 = 1000000; // 1 in fixed-point format
        int256 a2 = -500000; // -1/2 in fixed-point format
        
        return a0 + ((a2 * x * x) / (1000 * 1000));
    }
}