.. _recipes:

Available data packages
=======================

.. toctree::
   :hidden:
   :maxdepth: 1
   :glob:

   recipes/*/*

.. raw:: html

    <script src="recipes.json"></script>

    <body>
        <hr>
        <div class="container-fluid">
            <div class="row">
                <div class="col-sm-3">
                    <div class="form-group", id="channel_options">
                        <label for="channel_options">GGD Channel</label>
                        <select class="form-control" id="ggd_channel"></select>
                      </div>
                    </div>
                <div class="col=sm=4">
                    <div class="form-group", id="species_options">
                        <label for="species_options">Species</label>
                        <select class="form-control" id="species_select"></select>
                      </div>
                </div>
                <div class="col=sm=5 pl-3">
                    <div class="form-group", id="build_options">
                        <label for="build_options">Genome Build</label>
                        <select class="form-control" id="build_select">
                        </select>
                      </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    <p><center><small> NOTE: A <b>GGD Channel selection</b> is required before a <b>Species</b> selection and a <b>Species</b> selection is required before a <b>Genome Build</b> selection </small></center></p>
                </div>
            </div>
            <div class="row pt-3">
                <div class="col-12">
                    <table id="recipe_table"></table>
                </div>
            </div>
        </div>
    </body>



    <script>
    
        /*
        ------------------------------------------------------------------------------------------------------------------
                                                          Initiate
        ------------------------------------------------------------------------------------------------------------------
        */

        var cur_channel = "None"
        var cur_species = "None"
        var cur_build = "None"

        //Add channles to the GGD channel selector
        add_channel_selection()

        //Update view based on avaiable cookie info
        getCookie()

        /*
        ------------------------------------------------------------------------------------------------------------------
                                                         Populate Selectors
        ------------------------------------------------------------------------------------------------------------------
        */

        //Add ggd channel select options
        function add_channel_selection() {

            $("#ggd_channel").children().remove().end()
            $("#ggd_channel").append("<option>choose one</option>")

            for (channel of Object.keys(recipe_data)) {
                //Add region to select options
                $("#ggd_channel").append("<option>" + channel + "</option>")
            }

            if (cur_channel != "None") {
                //Set selected value
                $("#ggd_channel").val(cur_channel)
            }
        }

        //Add species selection options
        function add_species_selector() {

            //Update species selection
            $("#species_select").children().remove().end()
            $("#species_select").append("<option>choose one</option>")

            //Remove build info until a species is select
            $("#build_select").children().remove().end()

            //Update selection list
            if (cur_channel in recipe_data) {
                for (species of Object.keys(recipe_data[cur_channel])) {
                    $("#species_select").append("<option>" + species + "</option>")
                }
                
                //Set selected value
                if (cur_species != "None") {
                    $("#species_select").val(cur_species)
                }
            }
        }

        //Add build selection options
        function add_build_selector() {

            $("#build_select").children().remove().end()
            $("#build_select").append("<option>choose one</option>")

            //Update selection list
            if (cur_channel in recipe_data && cur_species in recipe_data[cur_channel]) {
                for (build of Object.keys(recipe_data[cur_channel][cur_species])) {
                    $("#build_select").append("<option>" + build + "</option>")
                }

                //Set selected value
                if (cur_build != "None") {
                    $("#build_select").val(cur_build)
                }
            }
        }

        /*
        ------------------------------------------------------------------------------------------------------------------
                                                         Display Recipes
        ------------------------------------------------------------------------------------------------------------------
        */

        //Method to remove recipe table
        function removeRecipeTable() {

            //Remove previous data table if it exists
            if ($.fn.DataTable.isDataTable('#recipe_table')) {
                let table = $('#recipe_table').DataTable()
                table.destroy();
                $('#recipe_table').empty();
            };
        }


        //Add a jQuery data table with recipe info
        function getRecipeTable(recipe_dict) {

            //Remove prexisting table
            removeRecipeTable()

            //Get the href strings for each recipe
            let hrefs = []
            Object.values(recipe_dict).forEach((href,i) => {
                hrefs.push([href])

            });

            //Create data table
            jQuery("#recipe_table").DataTable({
                destory: true,
                data: hrefs,
                columns: [{"title": "Packages", width: "20%"}],
                paging: false,
                scroller: true,
                scrollY: '60vh',
                scrollX: true,
                scrollCollapse: true,
                "dom": '<"pull-right"f><"pull-left"l>tip'
            });
        };

        /*
        ------------------------------------------------------------------------------------------------------------------
                                                         Event Handling
        ------------------------------------------------------------------------------------------------------------------
        */

        //Set local cookie info 
        function setCookie() {

            document.cookie = "channel = " + cur_channel + ";"
            document.cookie = "species = " + cur_species + ";" 
            document.cookie  = "build = " + cur_build + ";" 
        }

        //Unset local cookie info
        function unsetCookie() {

            document.cookie = "channel = " + "None" + ";"
            document.cookie = "species = " + "None" + ";" 
            document.cookie  = "build = " + "None" + ";" 

            console.log(document.cookie)
        }

        //Get Cookie info and update page 
        function getCookie() {

            var cookieElements = document.cookie.split(";")

            cookieElements.forEach(item => {

                if (item.split("=")[0].trim() == "channel") {
                    cur_channel = item.split("=")[1]
                } else if (item.split("=")[0].trim() == "species") {
                    cur_species = item.split("=")[1]
                } else if (item.split("=")[0].trim() == "build") {
                    cur_build = item.split("=")[1]

                }
            });

            //Add Channel Selection options
            add_channel_selection()
            add_species_selector()
            add_build_selector()

            //Add Recipe Table
            if (cur_build != "None") {
                getRecipeTable(recipe_data[cur_channel][cur_species][cur_build])
            }
        }

        //Select Channel
        /// Add species available for taht channel
        $("#ggd_channel").on('change', function(e) {
            var selectedValue = this.value
            
            //Unset the Cookie
            unsetCookie()

            //Keep track of current  channel
            cur_channel = selectedValue
            cur_species = "None"
            cur_build = "None"

            //Remove the recipe table
            removeRecipeTable()

            if (cur_channel == "choose one") {

                //Reset Selectors
                $("#species_select").children().remove().end()
                $("#build_select").children().remove().end()
                add_species_selector()
                add_build_selector()

            } else {

                add_species_selector()
                add_build_selector()
            }

        });

        //Select Species
        /// Add genome build available for that specices
        $("#species_select").on('change', function(e) {
            var selectedValue = this.value

            //Unset the Cookie
            unsetCookie()

            //Keep track of current species
            cur_species = selectedValue

            //Remove the recipe table
            removeRecipeTable()

            if (cur_species == "choose one") {

                //Reset build selector
                $("#build_select").children().remove().end()

            } else {

                add_build_selector()
            }

        });

        //Select build
        /// Add genome build available for that specices
        $("#build_select").on('change', function(e) {
            var selectedValue = this.value

            //Keep track of current species
            cur_build = selectedValue
            setCookie()

            if (cur_build == "choose one") {

                //Remove the recipe table
                removeRecipeTable()

            } else {

                getRecipeTable(recipe_data[cur_channel][cur_species][cur_build])
            }

        });
        

    </script>
