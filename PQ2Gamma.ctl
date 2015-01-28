

// 
// Convert PQ to Gamma
//




import "ACESlib.Utilities.a1.0.0";
import "ACESlib.Transform_Common.a1.0.0";




const float L_W = 1.0;
const float L_B = 0.0;



void main 
(
    input varying float rIn, 
    input varying float gIn, 
    input varying float bIn, 
    input varying float aIn,
    output varying float rOut,
    output varying float gOut,
    output varying float bOut,
    output varying float aOut,
    input uniform float CLIP=1000.0,
    input uniform float DISPGAMMA=2.4,
    input varying int legalRange = 0
)
{
	
    float PQ[3] = { rIn, gIn, bIn};

  // Decode with inverse PQ transfer function
    float linearCV[3] = pq_f_f3( PQ);

    
  // Clip range to where you want 1.0 in gamma to be
    linearCV = clamp_f3( linearCV, 0., CLIP);
    linearCV = mult_f_f3( 1.0/CLIP, linearCV);
    
  
  // Encode linear code values with transfer function
    float outputCV[3];
    outputCV[0] = bt1886_r( linearCV[0], DISPGAMMA, L_W, L_B);
    outputCV[1] = bt1886_r( linearCV[1], DISPGAMMA, L_W, L_B);
    outputCV[2] = bt1886_r( linearCV[2], DISPGAMMA, L_W, L_B);

  // Default output is full range, check if legalRange param was set to true
    if (legalRange == 1) {
      outputCV = fullRange_to_smpteRange_f3( outputCV);
    }

    rOut = outputCV[0];
    gOut = outputCV[1];
    bOut = outputCV[2];      
    aOut = aIn;
}
