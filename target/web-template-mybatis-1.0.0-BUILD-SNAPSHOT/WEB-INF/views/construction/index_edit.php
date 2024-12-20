<!doctype html>
<html lang="en">
<head>
	<?php include("combo.php");?>
    <title>보따리익스프레스 해외배송비 계산</title>
	<!-- Google Tag Manager -->
	<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
	new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
	j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
	'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
	})(window,document,'script','dataLayer','GTM-TWG38XQ');</script>
	<!-- End Google Tag Manager -->
	<meta charset="utf-8">   
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="css/style.css?1231" rel="stylesheet" media="screen and (min-width:1024px)">
    <link href="css/responsive.css?1335434" rel="stylesheet" type="text/css" media="screen and (max-width:1023px)">
    <link href="css/reset.css?123" rel="stylesheet">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.17.0/dist/jquery.validate.min.js"></script> 
	 <!-- 유효성 검증  -->
	 <script type="text/javascript">
            
            // 천단위 콤마 (소수점포함) 
            function numberWithCommas(num) { 
                var parts = num.toString().split("."); 
                return parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",") + (parts[1] ? "." + parts[1] : ""); 
            }



			function test(){
				
			}
            // 동작감지  
            $(document).ready(function(){
				
                //가격 조회버튼 클릭시                 
                $("#result_btn").on('click', function(){
					
                    console.log("버튼 클릭");
                    // 유효성 검증
                    $("#data_vl").validate({
						
                        // 유혀성 검증 룰 
                        rules: {
                            country: {
                                required : true,  //필수입력
                            },
                            weight: {
                                required : true, //필수입력
                                number : true, //숫자만  
                                min  : 0,  //최소길이 지정
                                max  : 1000   //최대길이 지정
                            },
                            width: {
                                required : true, //필수입력                                  
                                number : true, //숫자만  
                                min  : 0,  //최소길이 지정
                                max  : 1000  //최대길이 지정
                            },
                            vertical: {
                                required : true, //필수입력
                                number : true, //숫자만  
                                min  : 0,  //최소길이 지정
                                max  : 1000   //최대길이 지정
                            },
                            height: {
                                required : true, //필수입력
                                number : true, //숫자만  
                                min  : 0,  //최소길이 지정
                                max  : 1000   //최대길이 지정
                            }
                        },
                        // 오류 메시지 호출 
                        messages: {
                            country: {
                                required: "필수입력사항입니다."
                            },
                            weight: {
                                required: "무게 값은 필수 입력 값 입니다. ",
                                number: "무게 입력창은 숫자만 입력가능합니다.",
                                min : "무게값은 0 이상값만 입력이 가능합니다.",
                                max : "무게값은 1000 이하 숫자만 입력이 가능합니다."
                            },                           
                            width: {
                                required: "가로 값은 필수 입력 값 입니다. ",
                                number: "가로 입력창은 숫자만 입력가능합니다.",
                                min : "가로값은 0 이상값만 입력이 가능합니다.",
                                max : "가로값은 1000 이하 숫자만 입력이 가능합니다."
                            },                            
                            vertical: {
                                required: "세로 값은 필수 입력 값 입니다. ",
                                number: "세로 입력창은 숫자만 입력가능합니다.",
                                min : "세로값은 0 이상값만 입력이 가능합니다.",
                                max : "세로값은 1000 이하 숫자만 입력이 가능합니다."
                            },
                            height: {
                                required: "높이값은 필수 입력 값 입니다. ",
                                number: "높이 입력창은 숫자만 입력가능합니다.",
                                min : "높이값은 0 이상값만 입력이 가능합니다.",
                                max : "높이값은 1000 이하 숫자만 입력이 가능합니다."
                            }
                            
                        },
                        errorPlacement: function(err, element){
                        if(element.is(":radio") || element.is(":checkbox")){                            
                            element.parent().after(err);
                        }
						else if (element.is($('#width')) || element.is($('#vertical')) ||element.is($('#height')))
						{
							$('#validate_text').after(err) ;

						} 												
						else {
                            element.after(err);

                        }
                        },
                        submitHandler: function(){
                           // ajax 결과값 호출 
                            $.ajax({
                                        url: "result.php",
                                        type: "post",
                                        data: {
                                            country: $('#country').val(),
                                            weight: $('#weight').val(),
                                            num_value: $('#num_value').val()
                                        }
                                    }).done(function(data) {
                                        $('#result_vl').val(data);
                                    });    
                        }
                    });
                    
                });
				
                $( '#width, #vertical , #height').change( function() {
                   
                    var total = ((Number($('#width').val()) * Number($('#vertical').val() ) * Number($('#height').val() )) / 5000  )
                    

                    $('#num_value').val(numberWithCommas(total)) // 3자리마다 , 붙이기                    
                } );
				//배송대행 링크
				$("#proxyBt").click(function(){			
					//document.location.href='http://pf.kakao.com/_PDGxbxj';
					window.open('http://pf.kakao.com/_PDGxbxj');
					//document.location.href='http://pf.kakao.com/_PDGxbxj';
					return false;
				})
				$("#kakaoBt").click(function(){			
					window.open('http://pf.kakao.com/_PDGxbxj/chat');
					//document.location.href='http://pf.kakao.com/_PDGxbxj/chat';
					return false;
				})
				$("#emsBt").click(function(){			
					window.open('https://ems.epost.go.kr/front.EmsDeliveryDelivery01.postal');
					//document.location.href='https://ems.epost.go.kr/front.EmsDeliveryDelivery01.postal';
					return false;
				})
	
            });
    </script>
</head>
 <body>
	<!-- Google Tag Manager (noscript) -->
	<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-TWG38XQ"
	height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
	<!-- End Google Tag Manager (noscript) -->
	<!--wrap-->
	<div id="wrap">
		<!--inner-->
		<div class="inner1000">
			<!--item-head-->
			<div class="item-head">
				<img src="./images/logo.png" class="logo">
				<p>보따리 익스프레스 해외배송비 계산</p>
			</div>
			<!--//item-head-->
			<!--item-body-->
			
			<div class="item-body">
				<p class="text-1"> ※ 중량 또는 부피값 측정이 어려울 경우 숫자 "1을 넣어주시면 됩니다.</p>
				<form  id ="data_vl">
				<div class="formArea">
					<div class="f-top">해외특송(2-4일)</div> <p class="text-1" id = 'validate_text'>  </p>
					<!--국가선택-->
					<div class="formbox">
						<div class="title-put">
							국가선택
						</div>
						<div class="input-put">
							<select class="select01"  id = "country"  style="color: black;">
							<?php	
								$width;

								while($row = mysqli_fetch_array($jb_combo)) {
								echo '<option value="'.$row['ctry_nm'].'">'.$row['ctry_nm'].'</option>';
								
								}
									
							?>
							</select>
						</div>
					</div>

					<!--//국가선택-->
					<!--중량-->
					<div class="formbox bt-no">
						<div class="title-put"  >
							중량(kg)
						</div>
						<div class="input-put">
							<input type="text" class="input01" name ="weight" id ="weight">
						</div>
					</div>
					<!--//중량-->
					<!--부피-->
					<div class="formbox bt-no">
						<div class="title-put m-hi-143">
							부피(cm)
						</div>
						
						<div class="input-put flex m-column">
							<div class="m-flex">
								<input type="text" class="input02" placeholder="가로"  name="width" id="width">
								<span class="space">x</span>
								<input type="text" class="input02" placeholder="세로" name="vertical" id="vertical">
								<span class="space">x</span>
								<input type="text" class="input02" placeholder="높이" name= "height" id= "height">
							</div>
							<div>
								<span class="span1">/ 5000</span>
								<span class="space">=</span>
							</div>
							<input type="text" class="input02 pw160" readonly id="num_value">
						</div>
						
					</div>
					<!--//부피-->
					

					<button type="submit" class="submit_button" id="result_btn" >조회하기</button>
				    
					<!--예상배송비-->
					<div class="caption01">
						<p class="tit">예상배송비</p>
						<div class="inputbox">
							<input type="text" value="0" readonly id="result_vl" dir="rtl">
							<span class="s1">원</span>
						</div>
					    <div class="textArea">
							<p class="text1">※ 해외배송비는 중량무게와 부피무게를 비교하여 큰값으로 처리됩니다.</p>
							<p class="text1">※ 조회된 비용은 예상 배송비이며 실제 중량/무게에 따라 배송비는 변동될 수 있습니다.</p>
						</div>
					</div>
					<!--//예상배송비-->
					<img src="./images/240318_banner.jpg" style="width : 100%; margin-top : 40px;"/>
					<!--caption02-->
					<div class="caption02">
						<p>보따리익스프레스에서는</p>
						<p>해외 배송비 부담을 덜어드리기 위해</p>
						<p><span class="c-r">추가비용없이 부피 최소화 포장을 진행</span>해 드립니다.</p>

						<div class="img-bx flex">
							<div class="img-bx1">
								<img src="./images/img01.jpg">
							</div>
							<img src="./images/red-arrow.png" class="arrow">
							<div class="img-bx1">
								<img src="./images/img02.jpg">
							</div>
						</div>
					</div>
					<!--//caption02-->
					
					<!--caption03-->
					<div class="caption03">
						<ul>
							<li><button class="submit_button02 proxyBt" id ="proxyBt" name = "proxyBt" >배송대행 신청</button></li>
							<li><button class="submit_button02 kakaoBt" id ="kakaoBt" name = "kakaoBt">카카오톡 상담</button></li>
							<li><button class="submit_button02 emsBt" id ="emsBt" name = "emsBt">EMS배송비 조회</button></li>
						</ul>
					</div>
					<!--caption03-->

				</div>
				</form>	
			</div>
			<!--//item-body-->
		</div>
		<!--//inner-->
	</div>
	<!--//wrap-->
 </body>
</html>
