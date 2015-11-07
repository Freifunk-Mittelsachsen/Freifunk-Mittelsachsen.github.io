---
---

class FirmwareChoose
  constructor: (@formid) ->
    @downloadHost = "firmware.freifunk-waldheim.de"
    @fillForm()
    @config = window.ffmsconfig

  # json ziehen und formular füllen
  fillForm: ->
    @populateForm()
    @addFormCallback()

  # formular füllen mit vorhandenen routern
  populateForm: ->
    city = []
    manufacterer = []
    routertype = []
    hw_version = []
    _this = this

    jQuery.each window.ffmsconfig, (key,val) ->
      if key == "city"
        _this.appendToSelect("city",val)

      else if key == "manufacterer"
        _this.appendToSelect("manufacterer",val)

      else if key == "router"
        jQuery.each val, (key,router) ->
          name = router["name"]
          jQuery("<option value=\"#{key}\">#{name}</option>").appendTo("#routertype")


    jQuery("#routertype").on "change", (event) ->
      routertype = event.currentTarget.value
      # select leer machen
      jQuery("#hw-version").empty()

      # hw revisionen aus dem json
      #TODO reverse sortieren geht noch nciht bei loco
      hw_versions = window.ffmsconfig["router"][routertype]["hw_version"].reverse()

      jQuery.each hw_versions, (index) ->
        # select leer machen und mit aktuellen werten füllen
        hw_version = @[0]
        jQuery("#hw-version").append("<option value=\"#{hw_version}\">#{hw_version}</option>")

      # und wenn wir fertig sind das erste auswählen
      _this.selectFirst("#hw-version")

    # einmaliges triggern des changeevents
    jQuery("#routertype").trigger("change")
    @selectFirst("#routertype")
    @selectFirst("#hw-version")

    # link einklappen wenn sich im formular was ändert
    jQuery("#firmware-form").change ->
      jQuery("#dlcollapse").collapse('hide')
      jQuery("#downloadlink").empty()


  # form callback auführen
  addFormCallback: ->
    _this = this
    jQuery("#"+@formid).submit (event) ->
      event.preventDefault()
      _this.processForm(this)
      return
    return

  processForm: (form) ->
    city = $(form).find("#city").val()
    manufacterer = $(form).find("#manufacterer").val()
    routertype = $(form).find("#routertype").val()
    hw_version = $(form).find("#hw-version").val()
    installation_type = $(form).find("input[name=installtype]:checked").val()
    revision = window.ffmsconfig["revision"]
    downloadpath = "#{city}/#{installation_type}/#{revision}-#{manufacterer}-#{routertype}-v#{hw_version}.bin"

    downloadurl = "http://#{@downloadHost}/#{downloadpath}"
    # link erzeugen und ausklappen
    jQuery("#downloadlink").html("<a class=\"btn btn-success\" href=\"#{downloadurl}\">Firmware #{window.ffmsconfig["router"][routertype]["name"]}</a>")
    jQuery("#dlcollapse").collapse('show')



  # helper um selects zu füllen
  appendToSelect: (id,option) ->
    myid = "#" + id
    jQuery.each option, (key,myoption) ->
      option_html = "<option value=\"#{key}\">#{myoption}</option>"
      jQuery(myid).append(option_html)
    @selectFirst(myid)

  # erste option des selectes auswählen
  selectFirst: (myid) ->
    jQuery(myid + " option:first-child").attr("selected","selected")
    return true

jQuery(document).ready ->
  window.firmwareForm = new FirmwareChoose("firmware-form")
