function init() {
    /* Sort the search results */
    $('#section').on('click', 'thead a', function(event) {
        var url = $(this).attr('href');
        var results = $('#section');
        results.fadeTo('fast', 0.5);
        $.ajax(url)
        .done(function(data) {
            results.html(data);
            results.stop();
            results.fadeTo('fast', 1.0);
        })
        .fail(function(jqXHR) {
            var status_msg;
            try {
                var obj = $.parseJSON(jqXHR.responseText);
                status_msg = obj.status_msg;
            }
            catch(e) {
                status_msg = "Cannot Load Content";
            }
            showPermanentError($('#section'), status_msg);
        });

        return false;
    });

    /* View a user (show the modal editor) */
    $('#section').on('click', '[href*="#modalUser"]', function(event) {
        var modal = $('#modalUser');
        var url = $(this).attr('href');
        modal.empty();
        modal.modal({ shown: true });
        $.ajax(url)
            .done(function(data) {
                modal.append(data);
                modal.on('shown', function() {
                    $('#pid').focus();
                });
            })
            .fail(function(jqXHR) {
                var status_msg;
                modal.modal('hide');
                $("body,html").animate({scrollTop:0}, 'fast');
                try {
                    if (jqXHR.status == 404) {
                        $(window).hashchange();
                    }
                    else {
                        var obj = $.parseJSON(jqXHR.responseText);
                        status_msg = obj.status_msg;
                    }
                }
                catch(e) {
                    status_msg = "Cannot Load Content";
                }
                if (status_msg)
                    showError($('#section'), status_msg);
            });

        return false;
    });

    /* Save a node (from the modal editor) */
    $('body').on('click', '#updateUser', function(event) {
        var btn = $(this),
        modal = $('#modalUser'),
        form = modal.find('form').first(),
        modal_body = modal.find('.modal-body'),
        url = $(this).attr('href'),
        valid = false;
        btn.button('loading');
        valid = isFormValid(form);
        if (valid) {
            $.ajax({
                type: 'POST',
                url: url,
                data: form.serialize()
            }).done(function(data) {
                modal.modal('hide');
                modal.on('hidden', function() {
                    $(window).hashchange();
                });
            }).fail(function(jqXHR) {
                var status_msg;
                btn.button('reset');
                try {
                    var obj = $.parseJSON(jqXHR.responseText);
                    status_msg = obj.status_msg;
                }
                catch(e) {
                    status_msg = "Cannot Load Content";
                }
                resetAlert(modal_body);
                showPermanentError(modal_body.children().first(), obj.status_msg);
            });
        }

        return false;
    });

    /* Delete a user (from the modal editor) */
    $('body').on('click', '#deleteUser', function(event) {
        var modal = $('#modalUser');
        var url = $(this).attr('href');
        $.ajax(url)
            .done(function(data) {
                modal.modal('hide');
                modal.on('hidden', function() {
                    $(window).hashchange();
                });
            })
            .fail(function(jqXHR) {
                var status_msg;
                try {
                    var obj = $.parseJSON(jqXHR.responseText);
                    status_msg = obj.status_msg;
                }
                catch(e) {
                    status_msg = "Cannot Load Content";
                }
                showError($('#section h2'), status_msg);
                $("body,html").animate({scrollTop:0}, 'fast');
            });

        return false;    
    });

    /* Hash change handler */
    $(window).hashchange(function(event) {
        var hash = location.hash;
        if (hash == '') {
            hash = '#/user/search';
        }
        var href =  hash.replace(/^#/,'') + location.search ;
        updateSection(href);
        return true;
    });

    $(window).hashchange();
}