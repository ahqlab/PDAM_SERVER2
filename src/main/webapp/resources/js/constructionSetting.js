// common.js

console.log("===== Construction Setting 권한 확인 =====");

console.log("role:", constructionSetting.role);

console.log("isHiddenManager:", constructionSetting.isHiddenManager);


var useAdminReportTime = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useAdminReportTime , 'admin');
//console.log("useAdminReportTime:", useAdminReportTime);

var useGuestReportTime = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useGuestReportTime , 'guest');
//console.log("useGuestReportTime:", useGuestReportTime);

var useAdminPdf = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useAdminPdf , 'admin');
//console.log("useAdminPdf:", useAdminPdf);
var useGuestPdf = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useGuestPdf , 'guest');
//console.log("useGuestPdf:", useGuestPdf);

var useAdminExcel = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager,  constructionSetting.useAdminExcel , 'admin');
//console.log("useAdminExcel:", useAdminExcel);
var useGuestExcel = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useGuestExcel , 'guest');
//console.log("useGuestExcel:", useGuestExcel);

var useAdminTrash = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useAdminTrash , 'admin');
//console.log("useAdminTrash:", useAdminTrash);
var useGuestTrash = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useGuestTrash , 'guest');
//console.log("useGuestTrash:", useGuestTrash);

var useAdminEditReport = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useAdminEditReport , 'admin');
//console.log("useAdminEditReport:", useAdminEditReport);
var useGuestEditReport = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useGuestEditReport , 'guest');
//console.log("useGuestEditReport:", useGuestEditReport);

var useAdminDeleteReport = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useAdminDeleteReport , 'admin');
//console.log("useAdminDeleteReport:", useAdminDeleteReport);
var useGuestDeleteReport = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useGuestDeleteReport , 'guest');
//console.log("useGuestDeleteReport:", useGuestDeleteReport);

var useAdminRestoreReport = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useAdminRestoreReport , 'admin');
//console.log("useAdminRestoreReport:", useAdminRestoreReport);
var useGuestRestoreReport = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useGuestRestoreReport , 'guest');
console.log("useGuestRestoreReport:", useGuestRestoreReport);

var useAdminEditDai = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useAdminEditDai , 'admin');
console.log("useAdminEditDai:", useAdminEditDai);
var useGuestEditDai = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useGuestEditDai , 'guest');
console.log("useGuestEditDai:", useGuestEditDai);

var useAdminUbc = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useAdminUbc , 'admin');
console.log("useAdminUbc:", useAdminUbc);
var useGuestUbc = checkPermition(constructionSetting.role, constructionSetting.isHiddenManager, constructionSetting.useGuestUbc , 'guest');
console.log("useGuestUbc:", useGuestUbc);
console.log("=========================================");




function checkPermition(role, hiddenManager, permition, permitionType){
	
	console.log('role : ' + role);
	console.log('hiddenManager : ' + hiddenManager);
	console.log('permition : ' + permition);
	console.log('permitionType : ' + permitionType);
	
	if(role == 0){
		return true;
	}else if(role == 1){
		
		if(isHiddenManager){
			
			if(permition == true && permitionType == 'admin'){
				return true;
			}else{
				return  false;
			}
		}else{
			if(permition == true && permitionType == 'guest'){
				return true;
			}else{
				return false;
			}	
		}
	}else if(role == 2 || role == 3){
		
		if(permition == true && permitionType == 'guest'){
			return true;
		}else{
			return false;
		}
		
	}else if(role == 4){
		return false;
	}	
}



