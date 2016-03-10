## 카누 canoe

```
우리의 지금 결정은요
최선의 답은 구성원들의 의사에 따라 얼마든지 바뀔 수 있어야 합니다.
```

카누는 자신의 삶에 영향을 미칠 수 있는 문제에 대한 결정 과정에
누구든 참여하고 그 공동체가 스스로 자유롭게,
더 좋은 방향으로 나아갈 수 있도록 돕는 도구입니다.

* 프로젝트에 대한 이슈나 버그는 [여기](https://github.com/parti-xyz/canoe-web/issues)에 남겨주세요.
* 이 앱에 대한 기능 제안이나 이야기는 [카누](http://canoe.parti.xyz)안의 [더 나은 카누](http://canoe.parti.xyz/better-canoe)에서 계속할 수 있습니다.

## 로컬 개발 환경 구축

Rails 개발 환경에 rbenv를 이용합니다.

```
$ git clone https://github.com/parti-xyz/canoe-web.git
$ cd canoe-web && bundle
$ bundle exec rake db:setup
$ bundle exec rails s
```

## 연락하기

그래도 궁금한 점이나 나누고 싶은 이야기가 있으면 contact@parti.xyz로 알려주세요.

[twitter](https://twitter.com/parti_xyz) [facebook](https://www.facebook.com/parti.xyz) [medium](https://medium.com/parti-xyz-developers)

## 업그레이드 방법

### 버전 xxx

카누에 카운터 캐쉬를 넣었습니다. Rails console에서 아래를 수행합니다.

Canoe.find_each do |canoe|
    Canoe.reset_counters(canoe.id, :crews)
    Canoe.reset_counters(canoe.id, :discussions)
    Canoe.reset_counters(canoe.id, :opinions)
end

Opinion.counter_culture_fix_counts

Discussion.find_each do |discussion|
    Discussion.reset_counters(discussion.id, :opinions)
    Discussion.reset_counters(discussion.id, :proposals)
end
