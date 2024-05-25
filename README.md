**Main File**: Demo_Eye_On_Hand.m

**Data**: Store in data folder, pose and orientation from ROS



------

#### Core Function 1:

`X = EyeOnHand(E,S)`

Calibration Function



**Input:** 

- E: Hand to Base, 4\*4*n, n>=3
- S: Eye to Target, 4\*4*n, n>=3

- 3rd Input: Optional, Select Pair Measurement Method, default 3

  Pair Method:

  1. [1,2] [3,4] [5,6]

  2. [1,2] [1,3] [1,4], At Least 1st Measure can be Good

  3. [1,2] [2,3] [3,4], Incase Checker Board Moved during Calibration



**Output:**

- X: SE3, E1\*X\*S1 = E2\*X*S2



**Example:**

`X_calc = EyeOnHand(E,S);` 

`X_calc = EyeOnHand(E,S); % Debuge on the 4th Pair`

`X_calc = EyeOnHand(E,S,'Pair_Method',3); % Use 3rd Pair Method` 



------

#### Core Function 2:

`[err,str,frames] = EyeOnHandError(E,X,S)`

Calculate Calibration Error

Output see Example.