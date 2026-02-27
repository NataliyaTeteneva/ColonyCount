// README
// 
// Colony counting ImageJ Macro version 2
// 
// User manual
// 1. Take pictures of your plates (black&white, Tiff). They should be taken under the same conditions and have nice contrast and resolution.
// 2. Include a picture of an empty plate into your dataset. It should be taken under the same conditions as the rest of the plates.
// 3. Place all the pictures in one folder.
// 4. Prepare the picture of empty plate:
//	a. Use circular selection and EDIT>CLEAR OUTSIDE to select the plate and remove the background.
//	b. Crop the image using the same selection as before.
//  c. Save it in the folder.
// 5. In the section USER INPUT specify your empty plate image (bg) and save the script.
// 6. Hit "Run" and select the folder where you want to process the files. Be sure to only include image files in that folder.
// 7. Wait for the script to finish
// 8. Copy the results from Summary window to Excel.
// 9. Look through the photos to check for the obvious problems.
//
// Nataliya Teteneva, 08/2022

// USER INPUT

// empty plate
bg = "empty_cropped.Tif"

dir = getDirectory("Choose a Directory ");
files = getFileList(dir);

function count_plate(file, bg){
	open(file);
	run("Fit Circle to Image", "threshold=65034.86");
	run("Crop");
	run("Clear Outside");

	run("Brightness/Contrast...");
	//setMinAndMax(1, 49831);
	run("Apply LUT");

	open(dir+bg);
	imageCalculator("Subtract create", file, bg);
	selectWindow("Result of "+ file);
	run("Apply LUT");
	setAutoThreshold("Default dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");

	run("Watershed");
	run("Analyze Particles...", "size=20-Infinity circularity=0.50-1.00 display clear summarize add");
	run("Close All");
};

for (i = 0; i<files.length; i++) {
	count_plate(files[i], bg);
}
