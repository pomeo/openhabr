<!DOCTYPE html>
<html lang="ru">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- это для постов -->
<link href="/css/post_common_css.css" rel="stylesheet" media="all" />

<link href="/css/forms.css" rel="stylesheet" media="all" />
<link href="/css/posts.css" rel="stylesheet" media="all" />
<link href="/css/hubs_all.css" rel="stylesheet" media="all" />
<link href="/css/main.css" rel="stylesheet" media="all" />
</head>
<body>
<div id="layout">
<div id="navbar"></div>
<div class="inner">
<div class="column-wrapper">

<div class="item title required">
<form action="auth/login/" method="post">
	<label for="nickname">
		nickname (login):<sup class="required_field">*</sup>
	</label>
	<input type="text" name="nickname" value="">

        <label for="sword">
		password:<sup class="required_field">*</sup>
	</label>
	<input type="password" name="sword" value="">
<input type="hidden" name="return" value="{{{return}}}">
<input type="submit" class="btn btn_medium btn_grey" name="submit" value="здравствуйте">
</form>
</div>

</div>
</div>
{{>footer}}
</div>
</body>
</html>
