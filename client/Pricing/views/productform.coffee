class PricingProductForm extends JView
  constructor: (options = {}, data) ->
    options.cssClass = KD.utils.curry "product-form", options.cssClass
    super options, data

    @developerPlan = new DeveloperPlan
    @developerPlan.on "PlanSelected", @bound "selectPlan"

    @teamPlan = new TeamPlan cssClass: "hidden"
    @teamPlan.on "PlanSelected", @bound "selectPlan"

    @toggle        = new KDMultipleChoice
      cssClass     : "pricing-toggle"
      labels       : ["DEVELOPER", "TEAM"]
      defaultValue : ["DEVELOPER"]
      multiple     : no
      callback     : =>
        KD.singleton("router").handleRoute switch @toggle.getValue()
            when "DEVELOPER" then "/Pricing/Developer"
            when "TEAM" then "/Pricing/Team"

  showDeveloperPlan: ->
    @developerPlan.show()
    @teamPlan.hide()

  showTeamPlan: ->
    @developerPlan.hide()
    @teamPlan.show()

  selectPlan: (tag, options) ->
    KD.remote.api.JPaymentPlan.one tags: $in: [tag], (err, plan) =>
      return  if KD.showError err
      @emit "PlanSelected", plan, options

  pistachio: ->
    """
    <div class="inner-container">
      <header class="clearfix">
        <h2>Flexible Pricing for Developers and Teams</h2>
        <p>Either you are coding by yourself or coding with<br>your team, we got plans for you.</p>
        {{> @toggle}}
      </header>
      <div class="plan-selection">
        {{> @developerPlan}}
        {{> @teamPlan}}
      </div>
    </div>
    """
