import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { useState } from "react";
function app() {
  let [role, setRole] = useState("Solo Founder");
  let [stack, setStack] = useState("");
  let [techIdea, setTechIdea] = useState("");
  let [latencyReq, setLatencyReq] = useState("Real-time (<200ms)");
  let [result, setResult] = useState(null);
  let [loading, setLoading] = useState(false);
  let [loadingText, setLoadingText] = useState("Analyzing Architecture...");
  async function rotateLoadingMessages() {
    let messages = ["Analyzing Architecture...", "Calculating Latency Risks...", "Evaluating Tech Stack...", "Checking for Over-Engineering..."];
    for (const msg of messages) {
      setLoadingText(msg);
      await Promise(resolve => {
        setTimeout(resolve, 800);
      });
    }
  }
  async function handleSubmit() {
    setLoading(true);
    setResult(null);
    rotateLoadingMessages();
    let response = await __jacSpawn("FeasibilityConsultant", "", {"role": role, "stack": stack, "tech_idea": techIdea, "latency_req": latencyReq});
    if (response.result && len(response.result) > 0) {
      let assessment = response.result[0];
      setResult(assessment);
      print("Here are results");
    }
    setLoading(false);
  }
  function getScoreColor(score) {
    if (score >= 7) {
      return "#10B981";
    } else if (score >= 5) {
      return "#F59E0B";
    }
    return "#EF4444";
  }
  return __jacJsx("div", {"style": {"minHeight": "100vh", "background": "linear-gradient(135deg, #667eea 0%, #764ba2 100%)", "padding": "40px 20px", "fontFamily": "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif"}}, [__jacJsx("div", {"style": {"maxWidth": "800px", "margin": "0 auto", "background": "white", "borderRadius": "20px", "padding": "40px", "boxShadow": "0 20px 60px rgba(0,0,0,0.3)"}}, [__jacJsx("div", {"style": {"textAlign": "center", "marginBottom": "40px"}}, [__jacJsx("h1", {"style": {"fontSize": "48px", "fontWeight": "800", "background": "linear-gradient(135deg, #667eea 0%, #764ba2 100%)", "WebkitBackgroundClip": "text", "WebkitTextFillColor": "transparent", "marginBottom": "10px"}}, ["EVOLV"]), __jacJsx("p", {"style": {"fontSize": "18px", "color": "#6B7280", "fontWeight": "500"}}, ["The Ruthless CTO - Preventing Tech Gluttony"])]), __jacJsx("div", {"style": {"display": "flex", "flexDirection": "column", "gap": "24px"}}, [__jacJsx("div", {}, [__jacJsx("label", {"style": {"display": "block", "fontSize": "14px", "fontWeight": "600", "color": "#374151", "marginBottom": "8px"}}, ["Your Role"]), __jacJsx("select", {"value": role, "onChange": e => {
    setRole(e.target.value);
  }, "style": {"width": "100%", "padding": "12px 16px", "fontSize": "16px", "border": "2px solid #E5E7EB", "borderRadius": "10px", "outline": "none"}}, [__jacJsx("option", {"value": "Solo Founder"}, ["Solo Founder"]), __jacJsx("option", {"value": "Junior Developer"}, ["Junior Developer"]), __jacJsx("option", {"value": "Senior Engineer"}, ["Senior Engineer"]), __jacJsx("option", {"value": "Enterprise Team"}, ["Enterprise Team"])])]), __jacJsx("div", {}, [__jacJsx("label", {"style": {"display": "block", "fontSize": "14px", "fontWeight": "600", "color": "#374151", "marginBottom": "8px"}}, ["Current Tech Stack"]), __jacJsx("input", {"type": "text", "value": stack, "onChange": e => {
    setStack(e.target.value);
  }, "placeholder": "e.g., Python, Django, PostgreSQL", "style": {"width": "100%", "padding": "12px 16px", "fontSize": "16px", "border": "2px solid #E5E7EB", "borderRadius": "10px", "outline": "none"}}, [])]), __jacJsx("div", {}, [__jacJsx("label", {"style": {"display": "block", "fontSize": "14px", "fontWeight": "600", "color": "#374151", "marginBottom": "8px"}}, ["Proposed Tech Idea"]), __jacJsx("textarea", {"value": techIdea, "onChange": e => {
    setTechIdea(e.target.value);
  }, "placeholder": "e.g., Use LangChain Agent for contact form validation", "rows": "4", "style": {"width": "100%", "padding": "12px 16px", "fontSize": "16px", "border": "2px solid #E5E7EB", "borderRadius": "10px", "outline": "none", "resize": "vertical", "fontFamily": "inherit"}}, [])]), __jacJsx("div", {}, [__jacJsx("label", {"style": {"display": "block", "fontSize": "14px", "fontWeight": "600", "color": "#374151", "marginBottom": "8px"}}, ["Latency Requirement"]), __jacJsx("select", {"value": latencyReq, "onChange": e => {
    setLatencyReq(e.target.value);
  }, "style": {"width": "100%", "padding": "12px 16px", "fontSize": "16px", "border": "2px solid #E5E7EB", "borderRadius": "10px", "outline": "none"}}, [__jacJsx("option", {"value": "Real-time (<200ms)"}, ["Real-time (&lt;200ms)"]), __jacJsx("option", {"value": "Fast (<1s)"}, ["Fast (&lt;1s)"]), __jacJsx("option", {"value": "Moderate (<5s)"}, ["Moderate (&lt;5s)"]), __jacJsx("option", {"value": "Async (No Constraint)"}, ["Async (No Constraint)"])])]), __jacJsx("button", {"onClick": handleSubmit, "disabled": loading || !stack || !techIdea, "style": {"width": "100%", "padding": "16px", "fontSize": "18px", "fontWeight": "700", "color": "white", "background": loading || !stack || !techIdea ? "#9CA3AF" : "linear-gradient(135deg, #667eea 0%, #764ba2 100%)", "border": "none", "borderRadius": "10px", "cursor": loading || !stack || !techIdea ? "not-allowed" : "pointer", "transition": "transform 0.2s"}}, [loading ? "Consulting..." : "Get Assessment"])]), loading && __jacJsx("div", {"style": {"marginTop": "32px", "padding": "24px", "background": "#F3F4F6", "borderRadius": "12px", "textAlign": "center"}}, [__jacJsx("div", {"style": {"fontSize": "18px", "fontWeight": "600", "color": "#667eea", "animation": "pulse 2s infinite"}}, [loadingText])]), result && !loading && __jacJsx("div", {"style": {"marginTop": "32px", "padding": "32px", "background": result.score < 5 ? getScoreColor(result.score) : "#F3F4F6", "borderRadius": "16px", "border": "3px solid " + getScoreColor(result.score), "animation": "fadeIn 0.5s"}}, [__jacJsx("div", {"style": {"textAlign": "center", "marginBottom": "24px"}}, [__jacJsx("div", {"style": {"display": "inline-block", "padding": "16px 32px", "background": "white", "borderRadius": "50px", "boxShadow": "0 4px 12px rgba(0,0,0,0.1)"}}, [__jacJsx("span", {"style": {"fontSize": "48px", "fontWeight": "800", "color": getScoreColor(result.score)}}, [result.score, "/10"])])]), __jacJsx("div", {"style": {"textAlign": "center", "marginBottom": "24px"}}, [__jacJsx("span", {"style": {"fontSize": "28px", "fontWeight": "700", "color": result.score < 5 ? "white" : getScoreColor(result.score), "textTransform": "uppercase", "letterSpacing": "2px"}}, [result.verdict])]), len(result.red_flags) > 0 && __jacJsx("div", {"style": {"marginTop": "24px", "padding": "20px", "background": "white", "borderRadius": "12px"}}, [__jacJsx("h3", {"style": {"fontSize": "18px", "fontWeight": "700", "color": "#EF4444", "marginBottom": "12px"}}, ["🚨 Red Flags"]), __jacJsx("ul", {"style": {"margin": "0", "paddingLeft": "20px", "color": "#374151"}}, [result.red_flags.map(flag => {
    return __jacJsx("li", {"key": flag, "style": {"marginBottom": "8px", "fontSize": "15px", "lineHeight": "1.6"}}, [flag]);
  })])]), __jacJsx("div", {"style": {"marginTop": "24px", "padding": "20px", "background": "white", "borderRadius": "12px"}}, [__jacJsx("h3", {"style": {"fontSize": "18px", "fontWeight": "700", "color": "#10B981", "marginBottom": "12px"}}, ["💡 Boring Alternative (That Actually Works)"]), __jacJsx("p", {"style": {"margin": "0", "color": "#374151", "fontSize": "15px", "lineHeight": "1.6"}}, [result.alternative_plan])])])])]);
}
export { app };
