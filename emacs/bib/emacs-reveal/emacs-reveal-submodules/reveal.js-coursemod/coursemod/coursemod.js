(function () {
    'use strict';

    var config = Reveal.getConfig();

    if (config === null || typeof config.coursemod === 'undefined' || !config.coursemod.enabled)
        return;

    //disable when print-pdf is enabled
    if (window.location.href.indexOf('print-pdf') > -1)
        return;


    var holders = {
        presentation: undefined,
        courseView: undefined
    };

    function loadStylesheet() {
        var path = undefined;
        [].slice.call(document.getElementsByTagName('script')).forEach(function(script){
            if(script.src.indexOf('coursemod.js') > - 1) {
                path = script.src.split('/').slice(0, -1).join('/')+'/';
            }
        });

        var link = window.document.createElement('link');
        link.rel = 'stylesheet';
        link.href = path + 'coursemod.css';
        window.document.getElementsByTagName('head')[0].appendChild(link);
    }

    function setup() {
        loadStylesheet();
        holders.presentation = document.querySelector('.reveal');
        holders.presentation.classList.add('coursemod__presentation');

        var courseView = document.createElement('div');
        courseView.classList.add('coursemod__course-view');
        holders.presentation.parentNode.insertBefore(courseView, holders.presentation.nextElementSibling);
        holders.courseView = courseView;
    }

    function getSlideOverride(slide){
        if (typeof slide.dataset.coursemodShown !== 'undefined'){
            return slide.dataset.coursemodShown === 'true';
        }
        return undefined;
    }

    function toggleCourseView(show) {
        if(typeof show === 'undefined')
            show = config.coursemod.shown;
        if(show){
            holders.presentation.classList.add('coursemod--active')
            holders.courseView.classList.add('coursemod--active')
        }else{
            holders.presentation.classList.remove('coursemod--active')
            holders.courseView.classList.remove('coursemod--active')
        }
    }

    function updateNotes(currentSlide) {
        var notes = currentSlide.querySelector('aside.notes');
        if (notes !== null) {
            holders.courseView.innerHTML = notes.innerHTML;
        } else if(currentSlide.hasAttribute('data-notes')){
            holders.courseView.innerHTML = currentSlide.getAttribute('data-notes');
        } else {
            holders.courseView.innerHTML = '';
        }
    }

    if (typeof config.coursemod.shown === 'undefined') {
        config.coursemod.shown = true;
    }

    setup();
    updateNotes(Reveal.getCurrentSlide());

    var slideOverride = getSlideOverride(Reveal.getCurrentSlide());
    if(typeof slideOverride === 'undefined'){
        toggleCourseView(config.coursemod.shown);
    }else{
        toggleCourseView(slideOverride);
    }

    Reveal.addKeyBinding({keyCode: 86, key: 'V', description: 'Courseware view'}, function() {
        config.coursemod.shown = !config.coursemod.shown;
        toggleCourseView(config.coursemod.shown);
        Reveal.layout();
    });

    Reveal.addEventListener( 'slidechanged', function( event ) {
        var currentSlide = event.currentSlide;
        if (typeof currentSlide.dataset.coursemodShown !== 'undefined'){
            var show = currentSlide.dataset.coursemodShown === 'true';
            toggleCourseView(show);
        }else {
            toggleCourseView(config.coursemod.shown);
        }
        updateNotes(currentSlide);
	Reveal.layout();
    } );
}).call(this);
