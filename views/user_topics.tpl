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
  <div id="navbar" style="bottom: 29px;">
    <div class="nav_panel">
      <a href="/users/{{user.nickname}}/" class="tab tab_user" data-tab="user_tab" title="{{user.nickname}}">

          <img src="/img/avatars/{{user.nickname}}.jpg" class="author-info__image-pic">
                <span class="count navbar_count_new_messages"></span>
            </a>
<!-- если пользователь read-only - ссылка на публикацию в песочницу иначе - на новый пост -->
{{#user.readonly}}
            <a href="/sandbox/add/" class="tab tab_add_post" title="Новая публикация в песочницу">+</a>
{{/user.readonly}}
{{^user.readonly}}
            <a href="/posts/add/" class="tab tab_add_post" title="Новая публикация в общую ленту">+</a>
{{/user.readonly}}
    </div>

  </div>
<div class="inner">

<div class="profile-header">
  <div class="profile-header__summary author-info author-info_profile ">
    <a href="/users/{{profile.nickname}}/" class="author-info__image">
        <img src="/img/avatars/{{profile.nickname}}.jpg" class="author-info__image-pic">
    </a>

    <div class="author-info__desc">
      <div class="author-info__username">
         <a href="/users/{{profile.nickname}}/" class="author-info__name">{{profile.fullname}}</a> 
        <a href="/users/{{profile.nickname}}/" class="author-info__nickname">@{{profile.nickname}}</a>
        
      </div>
        <div class="author-info__specialization">
         {{profile.status}} 
        </div>
    </div>
  </div>

    <div class="profile-header__stats">

      <div class="karma__widjet voting-wjt js-karma  ">

        <div class="voting-wjt__counter js-karma-mark voting-wjt__counter_positive " title="971 голос">
          <div class="voting-wjt__counter-score js-karma_num">{{profile.carma}}</div>
          <div class="voting-wjt__label">карма</div>
        </div>

      </div>

      <div class="user-rating" title="Рейтинг пользователя">
        <div class="user-rating__value">{{profile.rating}}</div>
        <div class="user-rating__label">рейтинг</div>
      </div>

    </div>
    <div class="profile-header__buttons" style="display: inline-block;">
          <button type="button" class="btn btn_blue btn_large " id="followUser" title="Подписаться на пользователя" data-login="{{profile.nickname}}">Подписаться</button>

          <button type="button" class="btn btn_blue btn_subscribed btn_large hidden" id="unfollowUser" title="Вы подписаны на пользователя" data-login="{{profile.nickname}}">Подписан</button>
    </div>
</div>

<div class="column-wrapper">


<div class="tabs">
    <ul class="tabs-menu tabs-menu_habrahabr">
          <li class="tabs-menu__item tabs-menu__item_user-profile tabs-menu__item_inline">
            <a href="/users/{{profile.nickname}}/" class="tab-item tab-item_stacked ">
              <span class="tab-item__value stats">
                <span class="stats__counters stats__counters_big">
                  <strong class="counter"></strong>
                </span>
                <span class="stats__value">Профиль</span>
            </span></a>
          </li>
          <li class="tabs-menu__item tabs-menu__item_user-profile tabs-menu__item_inline">
            <a href="/users/{{profile.nickname}}/topics/" class="tab-item tab-item_stacked tab-item_current">
              <span class="tab-item__value stats">
                <span class="stats__counters stats__counters_big">
                  <strong class="counter">199</strong>
                </span>
                <span class="stats__value">Публикации</span>
            </span></a>
          </li>
          <li class="tabs-menu__item tabs-menu__item_user-profile tabs-menu__item_inline">
            <a href="/users/{{profile.nickname}}/comments/" class="tab-item tab-item_stacked ">
              <span class="tab-item__value stats">
                <span class="stats__counters stats__counters_big">
                  <strong class="counter">1,4k</strong>
                </span>
                <span class="stats__value todo">Комментарии</span>
            </span></a>
          </li>
          <li class="tabs-menu__item tabs-menu__item_user-profile tabs-menu__item_inline">
            <a href="/users/{{profile.nickname}}/favorites/" class="tab-item tab-item_stacked ">
              <span class="tab-item__value stats">
                <span class="stats__counters stats__counters_big">
                  <strong class="counter">53</strong>
                </span>
                <span class="stats__value todo">Избранное</span>
            </span></a>
          </li>
          <li class="tabs-menu__item tabs-menu__item_user-profile tabs-menu__item_inline">
            <a href="/users/{{profile.nickname}}/subscription/followers/" class="tab-item tab-item_stacked ">
              <span class="tab-item__value stats">
                <span class="stats__counters stats__counters_big">
                  <strong class="counter">274</strong>
                </span>
                <span class="stats__value todo">Подписчики</span>
            </span></a>
          </li>
    </ul>

  </div>

<div class="posts_list">
{{#articles}}
    <div class="posts shortcuts_items">
      <div class="post shortcuts_item" id="post_270673">
        <div class="published">сегодня в 20:15</div>
          <h1 class="title">
            <a href="/post/{{id}}/" class="post_title">{{title}}</a>
          </h1>
          <div class="hubs">
            {{#hubs}}
            <a href="/hub/{{name}}/" class="hub " title="Вы не подписаны на этот хаб" >{{title}}</a><span class="profiled_hub" title="Профильный хаб">*</span>
            {{/hubs}}
          </div>
          <div class="content html_format">
            {{{cut}}} 
            <div class="buttons">
              <a class="button habracut" href="/post/{{id}}/#habracut">{{cut_title}}</a>
            </div>
            <div class="clear"></div>
          </div>
          <div class="infopanel_wrapper">
            <ul class="postinfo-panel " id="infopanel_post_270673">
              <li class="postinfo-panel__item">
                <div class="voting-wjt voting-wjt_infopanel js-voting  ">
                <button type="button" disabled class="voting-wjt__button voting-wjt__button_plus js-plus" title="Read-only пользователи не могут голосовать">
                  <span>&uarr;</span>
                </button>

                <div class="voting-wjt__counter js-mark">
                  <span class="voting-wjt__result-score js-score" title="Оценка статьи пользователями">{{rating}}</span>
                </div>

                <button type="button" disabled class="voting-wjt__button voting-wjt__button_minus js-minus" title="Read-only пользователи не могут голосовать">
                  <span>&darr;</span>
                </button>
              </div>
            </li>
            <li class="postinfo-panel__item">
              <div class="views-count_post" title="Просмотры публикации">{{views}}</div>
            </li>
            <li class="postinfo-panel__item">
              <div class="favorite-wjt favorite">
                <button type="button" class="favorite-wjt__button add" data-id="{{id}}" title="Добавить в избранное" onclick="return posts_add_to_favorite(this);">
                  <span>В избранное</span>
                </button>
                <span class="favorite-wjt__counter js-favs_count" title="Количество пользователей, добавивших публикацию в избранное">{{favorites}}</span>
              </div>
            </li>
            <li class="postinfo-panel__item post-author">
              <a title="Автор публикации" class="post-author__link" href="/users/{{nickname}}/" >
                <img src="/img/avatars/{{nickname}}.jpg" class="post-author__pic"/>@{{nickname}}
              </a>
            </li>
            <li class="postinfo-panel__item postinfo-panel__item_comments">
              <div class="post-comments">
                <a href="/post/{{id}}/#comments" class="post-comments__link" title="Комментировать">
                  <span class="post-comments_all">Комментировать</span>
                </a>
              </div>
            </li>
          </ul>
        </div>
      </div>
{{/articles}}
</div>
</div>
</div>
{{>footer}}
</div>
</body>
</html>
