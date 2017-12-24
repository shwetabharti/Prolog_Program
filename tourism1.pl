/*Problem Statement: prologcontest2017 - Problem-5 */

:- import length/2,memberchk/2,append/3,member/2,ith/3 from basics.
:- import delete_ith/4 from listutil.



/*To Remove Duplicates from a List*/
removeDuplicate([],[]).
removeDuplicate([X],[X]).
removeDuplicate([X,Y|Xs],[X|L]):-
	X \= Y,
	removeDuplicate([Y|Xs],L).
removeDuplicate([X,X|Xs],L):-
	removeDuplicate([X|Xs],L).
	  
/*Getting List of Persons Preferences*/
peoplesPref(Pref):- /*PrefList has all preferences*/
	people(Peoplenum),
	orderPref(Peoplenum,Temp_peoplenum),
	my_flatten(Temp_peoplenum,Pref).

orderPref(Num,[H|T]):-
	Num > 0,
	bagof([X,Y], order(Num,X,Y), Temp1),
	my_flatten(Temp1,Temp2),
	removeDuplicate(Temp2,Temp3),
	placePairs(Temp3,H),
	Num1 is Num-1,
	orderPref(Num1,T).
	  
orderPref(0,[]).

/*Creating list of Locations*/
location_list(0,[]).
location_list(NumLoc,L):-
	L=[NumLoc|L1],
	NumLoc1 is NumLoc-1,
	location_list(NumLoc1,L1).
	
finalLocationList(FinalPlace):-  /* Final Function that gives List of Location*/
	places(NumPlace),
	location_list(NumPlace,FinalPlace).
	
delete(X,[X|Y],Y).
delete(X,[X],[]).
delete(X,[Y|Ys],[Y|L]):-
	delete(X,Ys,L).

select(H, [H|T], [H|T]).
select(X, [H|T], [H|T2]):-
	select(X, T, T2).
	
if_present(H, [H|T]).
if_present(X,[H|T]):-
	if_present(X,T).
	
/*To Create Permutations of Location List*/
permute([], []).
permute([X|Xs], Ys):-
	permute(Xs,Zs),
	delete(X,Ys,Zs).
	
/*Getting Permutations of the Locations*/ 
permuteLocation(PermList):-  /*Final Function to get the list of all permuted locations*/
	finalLocationList(PlaceList),
	setof(Y,permute(PlaceList,Y),PermList).

/*Making Pairs of a the Permutation of the Places List*/
makepair([X|Xs],[H|T]):-
	pairHelper(X,Xs,H),
	makepair(Xs,T).

pairHelper(K,[X|Xs],[[K,X]|T]):-
	pairHelper(K,Xs,T).
pairHelper(K,[],[]).
makepair([],[]).

placePairs(X,Z):-  /*This final function return all pairs of places in the permutation list, X = Input Location Permutation List, Y=Output */
	makepair(X,Y),
	my_flatten(Y,Z).
	
/*Flattenning the List*/
my_flatten(X,[X]) :- 
	\+ is_list(X).
my_flatten([],[]).
my_flatten([X|Xs],Zs) :- 
	my_flatten(Xs,Ys), 
	append(X,Ys,Zs).

if_present(H, [H|T]).
if_present(X,[H|T]):-
	if_present(X,T).
	
/*To Count Number of Violations*/
callCount(X,Y,M):- 	/*Final Program to Count The violations*/
	countViolation(X,Y,0,M).

countViolation([],Y,K,K).
countViolation([X|Xs],Y,K,M):-
		if_present(X,Y),
		countViolation(Xs,Y,K,M).

countViolation([X|Xs],Y,K,M):-
		\+ if_present(X,Y),
		K1 is K+1,
		countViolation(Xs,Y,K1,M).		
		
countViolation([],Y,K,K).

pairofPerms([X|Xs],[H|T]):-
	placePairs(X,H),
	pairofPerms(Xs,T).

pairofPerms([],[]).

placeList(L):-
	permuteLocation(X),
	pairofPerms(X,L).

callviolationsCount(Pref,[H|T],[L|L1]):-
	/*my_flatten(H,PermList),*/
	violationsCount(Pref,H,L),
	callviolationsCount(Pref,T,L1).
	
callviolationsCount(Pref,[],[]).

violations(X):-
	peoplesPref(Pref),
	placeList(Perms),
	callviolationsCount(Pref,Perms,ViolList),
	min(ViolList,9999,X).
	
violationsCount(Pref,Perms,T):-
	callCount(Pref,Perms,T).

violationsCount(Pref, [], []).

min([],K,K).
min([X|Xs],K,T):-
	(	
		X < K 
		->
		min(Xs, X, T);
		min(Xs, K, T)
	).