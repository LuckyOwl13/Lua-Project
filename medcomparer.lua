-- Caitlin E. McElwee

-- Reads input containing an integer N on a line by itself, representing the number of patients in the list. 
-- This is followed by N lines, each containing four integers: 
-- a patient number, then three numbers (1 or 0) for whether patient has disease, tested pos on test 1, tested pos on test 2.
-- The output is four conditional probabilities:
-- P(Diseased|Pos1)
-- P(Diseased|Pos2)
-- P(Healthy|Pos1)
-- P(Healthy|Pos2)
-- Then one of the following three messages: "Test 1 is better", "Test 2 is better", or "Neither test is better".

-- Revised November 2017

function medcomparer()
	
	patients = {}
	total = io.read("*n")
	for i=1,total do
		io.write("Next patient: ")
		local number,sick,test1,test2 = io.read("*n","*n","*n","*n")
		table.insert(patients,{number,sick,test1,test2})
		io.write(number,sick,test1,test2,"\n")
	end
	
	
	YesSick1 = 0	-- # rightly sick patients for test1
	YesSick2 = 0	-- # rightly sick patients for test2
	
	YesFine1 = 0	-- # rightly fine patients for test1
	YesFine2 = 0	-- # rightly fine patients for test2
	
	Pos1Count = 0	-- # patients who were positive for test1
	Pos2Count = 0	-- # patients who were positive for test2
	
	Neg1Count = 0   -- # patients who were negitive for test1
	Neg2Count = 0   -- # patients who were negitive for test2
	

	
	for i=1,total  do
		if patients[i][2] == 0 then	-- Given the patient is actually healthy...
			if patients[i][3] == 0 then	-- Test1 correctly ignored healthy patient
				YesFine1 = YesFine1 + 1
				Neg1Count = Neg1Count + 1
			else	-- Test1 falsely flagged healthy patient
				Pos1Count = Pos1Count + 1
			end
			if patients[i][4] == 0 then	-- Test2 correctly ignored healthy patient
				YesFine2 = YesFine2 + 1
				Neg2Count = Neg2Count + 1
			else	-- Test2 falsely flagged healthy patient
				Pos2Count = Pos2Count + 1
			end
		else	-- Given the patient is actually sick...
			if patients[i][3] == 1 then	-- Test1 correctly flagged diseased patient
				YesSick1 = YesSick1 + 1
				Pos1Count = Pos1Count + 1
			else	-- Test1 falsely ignored diseased patient
				Neg1Count = Neg1Count + 1
			end
			if patients[i][4] == 1 then	-- Test2 correctly flagged diseased patient
				YesSick2 = YesSick2 + 1
				Pos2Count = Pos2Count + 1
			else	-- Test2 falsely ignored diseased patient
				Neg2Count= Neg2Count + 1
			end
		end
	end	-- end for
	
	
	-- Calculate probabilities
	DgivenPos1 = YesSick1 / Pos1Count
	DgivenPos2 = YesSick2 / Pos2Count
	HgivenPos1 = YesFine1 / Neg1Count
	HgivenPos2 = YesFine2 / Neg2Count
	
	io.write("P(D | Pos1) = ",DgivenPos1,"\n")
	io.write("P(D | Pos2) = ",DgivenPos2,"\n")
	io.write("P(H | Neg1) = ",HgivenPos1,"\n")
	io.write("P(H | Neg2) = ",HgivenPos2,"\n")
	
	
	-- Calculate the results: which test is better for 1) detecting the sick and 2) ignoring the healthy?
	Results = {}
	Results[1] = DgivenPos1 - DgivenPos2  -- If pos, test1 better if neg, test2 better.
	Results[2] = HgivenPos1 - HgivenPos2  -- If 0, equal.
	
	
	-- Figure out which test is better: if both positive, test1 better if both negative, test2 better. If mixed or even, no test better
	if (Results[1] > 0) and (Results[2] > 0) then
		io.write("Test 1 is better.\n")
	elseif (Results[1] < 0 and Results[2] < 0) then
		io.write("Test 2 is better.\n")
	else
		io.write("Neither test is better.\n")
	end
	
end

medcomparer()
