import { useState } from "react";

const COLORS = {
  primary: "#0A2463",
  accent: "#3E92CC",
  success: "#06D6A0",
  warning: "#FFB703",
  danger: "#EF233C",
  surface: "#F8F9FC",
  divider: "#E2E8F0",
  textPrimary: "#0D1B2A",
  textSecondary: "#64748B",
};

const PROJECTS = [
  {
    id: "1",
    title: "AIIMS Pune Phase 2 Expansion",
    category: "hospital",
    emoji: "🏥",
    description: "Construction of 3 new OPD blocks with 500 additional beds, ICU facility and modern diagnostic labs under PM-ABHIM scheme.",
    status: "Under Construction",
    lat: 18.5204, lng: 73.8567,
    geofence: 500,
    budget: 4200, spent: 2730,
    completion: 65,
    startDate: "Jan 2023", endDate: "Dec 2025",
    department: "Ministry of Health & Family Welfare",
    contractor: "L&T Construction Ltd.",
    impacts: [
      { icon: "🏥", label: "New Beds", value: "500+" },
      { icon: "👨‍⚕️", label: "Doctors Hired", value: "120" },
      { icon: "👥", label: "Citizens Benefited", value: "8 Lakh" },
      { icon: "🧪", label: "New Labs", value: "14" },
    ],
    updates: [
      { date: "Dec 2024", title: "ICU Block Foundation Complete", desc: "Foundation work for the 120-bed ICU block completed ahead of schedule." },
      { date: "Oct 2024", title: "Phase 2 OPD Roof Slab Done", desc: "Roof slab casting completed for OPD Block B." },
    ],
  },
  {
    id: "2",
    title: "Pune Metro Line 3 — Hinjewadi Corridor",
    category: "metro",
    emoji: "🚇",
    description: "Underground metro rail from Hinjewadi IT Park to Shivajinagar, 23.3 km with 23 stations.",
    status: "Under Construction",
    lat: 18.5913, lng: 73.7389,
    geofence: 800,
    budget: 8313, spent: 4990,
    completion: 60,
    startDate: "Jun 2022", endDate: "Mar 2026",
    department: "PMRDA",
    contractor: "Siemens Mobility + ITD Cementation",
    impacts: [
      { icon: "🚇", label: "Stations", value: "23" },
      { icon: "📏", label: "Route Length", value: "23.3 km" },
      { icon: "👥", label: "Daily Riders", value: "3.5 Lakh" },
      { icon: "🌱", label: "CO₂ Saved/yr", value: "48,000 T" },
    ],
    updates: [
      { date: "Jan 2025", title: "Tunnel Boring 70% Done", desc: "TBM has covered 16.3 km of the 23.3 km stretch." },
    ],
  },
  {
    id: "3",
    title: "Alandi Smart Water Supply Grid",
    category: "water",
    emoji: "💧",
    description: "End-to-end smart water distribution with IoT flow sensors, automated billing and leak detection.",
    status: "Completed",
    lat: 18.6742, lng: 73.8988,
    geofence: 400,
    budget: 340, spent: 312,
    completion: 100,
    startDate: "Mar 2023", endDate: "Sep 2024",
    department: "Pune Municipal Corporation",
    contractor: "Jain Irrigation Systems",
    impacts: [
      { icon: "💧", label: "Households", value: "18,500" },
      { icon: "📉", label: "Wastage Reduced", value: "34%" },
      { icon: "⏱️", label: "Supply Hours", value: "16h→22h" },
      { icon: "📱", label: "Smart Meters", value: "18,500" },
    ],
    updates: [
      { date: "Sep 2024", title: "Project Commissioned", desc: "Full network live. All 18,500 smart meters active." },
    ],
  },
  {
    id: "4",
    title: "NH-48 Pune–Mumbai Expressway Widening",
    category: "road",
    emoji: "🛣️",
    description: "6-lane to 8-lane expansion of the expressway with smart toll and anti-fog lighting systems.",
    status: "Approved",
    lat: 18.4529, lng: 73.8012,
    geofence: 1000,
    budget: 1800, spent: 120,
    completion: 8,
    startDate: "Mar 2025", endDate: "Jun 2027",
    department: "NHAI",
    contractor: "Dilip Buildcon Ltd.",
    impacts: [
      { icon: "🚗", label: "Lanes Added", value: "2" },
      { icon: "⏱️", label: "Travel Time Saved", value: "35 min" },
      { icon: "🔒", label: "Accident Reduction", value: "60%" },
    ],
    updates: [],
  },
];

const CATEGORIES = [
  { id: "all", label: "All", emoji: "🗺️" },
  { id: "hospital", label: "Health", emoji: "🏥" },
  { id: "metro", label: "Metro", emoji: "🚇" },
  { id: "water", label: "Water", emoji: "💧" },
  { id: "road", label: "Road", emoji: "🛣️" },
];

const STATUS_COLORS = {
  "Completed": COLORS.success,
  "Under Construction": COLORS.warning,
  "Approved": COLORS.accent,
  "Planning": COLORS.textSecondary,
  "Paused": COLORS.danger,
};

function StatusBadge({ status }) {
  const color = STATUS_COLORS[status] || COLORS.accent;
  return (
    <span style={{
      background: color + "20", color, fontSize: 11, fontWeight: 700,
      padding: "3px 10px", borderRadius: 7, display: "inline-block",
    }}>
      {status}
    </span>
  );
}

function ProgressBar({ value, color = COLORS.accent, height = 6 }) {
  return (
    <div style={{ background: COLORS.divider, borderRadius: height, overflow: "hidden", height }}>
      <div style={{
        width: `${value}%`, height, borderRadius: height,
        background: value === 100
          ? `linear-gradient(90deg, ${COLORS.success}, #10B981)`
          : `linear-gradient(90deg, ${COLORS.accent}, ${COLORS.success})`,
        transition: "width 1s ease",
      }} />
    </div>
  );
}

function ProjectDetailView({ project, onBack }) {
  return (
    <div style={{ flex: 1, overflowY: "auto", background: COLORS.surface }}>
      {/* Hero */}
      <div style={{
        background: `linear-gradient(135deg, ${COLORS.primary} 0%, ${COLORS.accent} 100%)`,
        padding: "20px 20px 28px",
        position: "relative",
      }}>
        <button onClick={onBack} style={{
          background: "rgba(255,255,255,0.2)", border: "none", color: "#fff",
          borderRadius: 10, padding: "6px 12px", cursor: "pointer",
          marginBottom: 16, display: "flex", alignItems: "center", gap: 6, fontSize: 13,
        }}>
          ← Back
        </button>
        <div style={{ fontSize: 11, color: "rgba(255,255,255,0.6)", letterSpacing: 2, marginBottom: 6, textTransform: "uppercase" }}>
          {project.category}
        </div>
        <div style={{ fontSize: 22, fontWeight: 800, color: "#fff", lineHeight: 1.3 }}>{project.title}</div>
      </div>

      <div style={{ padding: 16, display: "flex", flexDirection: "column", gap: 14 }}>
        {/* Info card */}
        <div style={{ background: "#fff", borderRadius: 18, border: `1px solid ${COLORS.divider}`, padding: 18 }}>
          <div style={{ display: "flex", gap: 8, marginBottom: 14, flexWrap: "wrap" }}>
            <StatusBadge status={project.status} />
            <span style={{
              background: COLORS.surface, border: `1px solid ${COLORS.divider}`,
              fontSize: 11, padding: "3px 10px", borderRadius: 7, color: COLORS.textSecondary, fontWeight: 500,
            }}>
              📍 {project.department}
            </span>
          </div>
          <p style={{ color: COLORS.textSecondary, fontSize: 13, lineHeight: 1.7, margin: "0 0 14px" }}>{project.description}</p>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 8 }}>
            {[
              { label: "Start", value: project.startDate },
              { label: "End", value: project.endDate },
              { label: "Contractor", value: project.contractor.split(" ")[0] },
            ].map(m => (
              <div key={m.label} style={{ textAlign: "center" }}>
                <div style={{ fontSize: 12, color: COLORS.textSecondary }}>{m.label}</div>
                <div style={{ fontSize: 12, fontWeight: 700, color: COLORS.textPrimary }}>{m.value}</div>
              </div>
            ))}
          </div>
        </div>

        {/* Progress */}
        <div style={{ background: "#fff", borderRadius: 18, border: `1px solid ${COLORS.divider}`, padding: 18 }}>
          <div style={{ fontWeight: 700, fontSize: 15, marginBottom: 14 }}>Completion Progress</div>
          <ProgressBar value={project.completion} height={12} />
          <div style={{ display: "flex", justifyContent: "space-between", marginTop: 8 }}>
            <span style={{ fontWeight: 700, color: COLORS.primary }}>{project.completion}% Complete</span>
            <span style={{ color: COLORS.textSecondary, fontSize: 13 }}>{100 - project.completion}% Remaining</span>
          </div>
        </div>

        {/* Civic Impact */}
        {project.impacts.length > 0 && (
          <div style={{
            borderRadius: 18,
            background: `linear-gradient(135deg, ${COLORS.primary}, ${COLORS.accent})`,
            padding: 18,
          }}>
            <div style={{ color: "#fff", fontWeight: 700, fontSize: 15, marginBottom: 14 }}>👥 Civic Impact</div>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
              {project.impacts.map((imp, i) => (
                <div key={i} style={{
                  background: "rgba(255,255,255,0.15)", borderRadius: 12, padding: "10px 14px",
                  display: "flex", alignItems: "center", gap: 10,
                }}>
                  <span style={{ fontSize: 22 }}>{imp.icon}</span>
                  <div>
                    <div style={{ color: "#fff", fontWeight: 800, fontSize: 15 }}>{imp.value}</div>
                    <div style={{ color: "rgba(255,255,255,0.7)", fontSize: 11 }}>{imp.label}</div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Budget */}
        <div style={{ background: "#fff", borderRadius: 18, border: `1px solid ${COLORS.divider}`, padding: 18 }}>
          <div style={{ fontWeight: 700, fontSize: 15, marginBottom: 14 }}>💰 Budget Transparency</div>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 8, textAlign: "center" }}>
            {[
              { label: "Sanctioned", value: `₹${project.budget} Cr`, color: COLORS.primary },
              { label: "Utilized", value: `₹${project.spent} Cr`, color: COLORS.accent },
              { label: "Utilization", value: `${Math.round((project.spent / project.budget) * 100)}%`, color: COLORS.success },
            ].map(b => (
              <div key={b.label}>
                <div style={{ fontSize: 18, fontWeight: 800, color: b.color }}>{b.value}</div>
                <div style={{ fontSize: 11, color: COLORS.textSecondary }}>{b.label}</div>
              </div>
            ))}
          </div>
        </div>

        {/* Updates */}
        {project.updates.length > 0 && (
          <div style={{ background: "#fff", borderRadius: 18, border: `1px solid ${COLORS.divider}`, padding: 18 }}>
            <div style={{ fontWeight: 700, fontSize: 15, marginBottom: 14 }}>🗓️ Recent Updates</div>
            {project.updates.map((u, i) => (
              <div key={i} style={{ display: "flex", gap: 14, marginBottom: i < project.updates.length - 1 ? 16 : 0 }}>
                <div style={{ display: "flex", flexDirection: "column", alignItems: "center" }}>
                  <div style={{ width: 10, height: 10, borderRadius: "50%", background: COLORS.accent, flexShrink: 0, marginTop: 2 }} />
                  {i < project.updates.length - 1 && <div style={{ width: 2, flex: 1, background: COLORS.divider, marginTop: 4 }} />}
                </div>
                <div>
                  <div style={{ fontSize: 11, color: COLORS.textSecondary }}>{u.date}</div>
                  <div style={{ fontWeight: 700, fontSize: 13 }}>{u.title}</div>
                  <div style={{ fontSize: 12, color: COLORS.textSecondary, marginTop: 2 }}>{u.desc}</div>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Geo-fence info */}
        <div style={{
          background: COLORS.primary + "10", borderRadius: 14, padding: 14,
          border: `1px solid ${COLORS.primary}30`, display: "flex", alignItems: "center", gap: 12,
        }}>
          <div style={{ fontSize: 28 }}>📡</div>
          <div>
            <div style={{ fontWeight: 700, fontSize: 13, color: COLORS.primary }}>Geo-fence Active</div>
            <div style={{ fontSize: 12, color: COLORS.textSecondary }}>You will be notified within {project.geofence}m of this project</div>
          </div>
        </div>
      </div>
    </div>
  );
}

function CitizenApp() {
  const [tab, setTab] = useState("feed");
  const [selectedProject, setSelectedProject] = useState(null);
  const [filterCat, setFilterCat] = useState("all");
  const [notification, setNotification] = useState(null);

  const filtered = PROJECTS.filter(p => filterCat === "all" || p.category === filterCat);

  const triggerNotification = (p) => {
    setNotification(p);
    setTimeout(() => setNotification(null), 4000);
  };

  if (selectedProject) {
    return (
      <div style={{ display: "flex", flexDirection: "column", height: "100%" }}>
        <ProjectDetailView project={selectedProject} onBack={() => setSelectedProject(null)} />
      </div>
    );
  }

  return (
    <div style={{ display: "flex", flexDirection: "column", height: "100%", position: "relative" }}>
      {/* Notification toast */}
      {notification && (
        <div style={{
          position: "absolute", top: 12, left: 12, right: 12, zIndex: 100,
          background: COLORS.primary, borderRadius: 16, padding: "14px 16px",
          boxShadow: "0 8px 32px rgba(10,36,99,0.35)",
          display: "flex", alignItems: "flex-start", gap: 12,
          animation: "slideDown 0.3s ease",
        }}>
          <span style={{ fontSize: 28, flexShrink: 0 }}>{notification.emoji}</span>
          <div>
            <div style={{ color: "#fff", fontWeight: 700, fontSize: 13 }}>{notification.title}</div>
            <div style={{ color: "rgba(255,255,255,0.75)", fontSize: 11, marginTop: 2 }}>
              You are near this project • {notification.completion}% complete
            </div>
          </div>
          <button onClick={() => setNotification(null)} style={{ background: "none", border: "none", color: "rgba(255,255,255,0.6)", cursor: "pointer", marginLeft: "auto", fontSize: 16 }}>✕</button>
        </div>
      )}

      {/* App Bar */}
      <div style={{
        background: COLORS.primary, padding: "14px 16px 12px",
        display: "flex", justifyContent: "space-between", alignItems: "flex-start",
      }}>
        <div>
          <div style={{ color: "#fff", fontWeight: 800, fontSize: 20 }}>CivicPulse</div>
          <div style={{ color: "rgba(255,255,255,0.6)", fontSize: 11 }}>Your Government. Your Progress.</div>
        </div>
        <div style={{ width: 36, height: 36, borderRadius: "50%", background: "rgba(255,255,255,0.2)", display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer" }}>
          <span style={{ color: "#fff", fontSize: 18 }}>🔔</span>
        </div>
      </div>

      {/* Body */}
      <div style={{ flex: 1, overflowY: "auto", background: COLORS.surface }}>
        {tab === "feed" && (
          <div style={{ padding: 16 }}>
            {/* Hero */}
            <div style={{
              background: `linear-gradient(135deg, ${COLORS.primary}, ${COLORS.accent})`,
              borderRadius: 20, padding: "20px 20px",
              display: "flex", justifyContent: "space-between", alignItems: "center",
              marginBottom: 20,
            }}>
              <div>
                <div style={{ color: "rgba(255,255,255,0.7)", fontSize: 12 }}>📍 Pune, Maharashtra</div>
                <div style={{ color: "#fff", fontSize: 24, fontWeight: 800, marginTop: 4 }}>
                  {PROJECTS.filter(p => p.status !== "Completed").length} Active Projects
                </div>
                <div style={{ color: "rgba(255,255,255,0.7)", fontSize: 13 }}>
                  {PROJECTS.filter(p => p.status === "Completed").length} Completed
                </div>
              </div>
              <span style={{ fontSize: 48 }}>🏛️</span>
            </div>

            {/* Category filter */}
            <div style={{ display: "flex", gap: 8, marginBottom: 20, overflowX: "auto", paddingBottom: 4 }}>
              {CATEGORIES.map(c => (
                <button key={c.id} onClick={() => setFilterCat(c.id)} style={{
                  background: filterCat === c.id ? COLORS.primary : "#fff",
                  color: filterCat === c.id ? "#fff" : COLORS.textSecondary,
                  border: `1px solid ${filterCat === c.id ? COLORS.primary : COLORS.divider}`,
                  borderRadius: 20, padding: "7px 14px", fontSize: 13, fontWeight: 600, cursor: "pointer",
                  whiteSpace: "nowrap", display: "flex", alignItems: "center", gap: 6,
                  transition: "all 0.2s",
                }}>
                  {c.emoji} {c.label}
                </button>
              ))}
            </div>

            {/* Project list */}
            <div style={{ fontWeight: 800, fontSize: 16, marginBottom: 12, color: COLORS.textPrimary }}>
              🚧 All Projects
            </div>
            <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
              {filtered.map(p => (
                <div key={p.id}
                  onClick={() => setSelectedProject(p)}
                  style={{
                    background: "#fff", borderRadius: 18, border: `1px solid ${COLORS.divider}`,
                    padding: 16, cursor: "pointer",
                    transition: "box-shadow 0.2s",
                  }}
                >
                  <div style={{ display: "flex", alignItems: "flex-start", gap: 12, marginBottom: 10 }}>
                    <div style={{
                      width: 44, height: 44, borderRadius: 12, background: COLORS.surface,
                      display: "flex", alignItems: "center", justifyContent: "center", fontSize: 22, flexShrink: 0,
                    }}>{p.emoji}</div>
                    <div style={{ flex: 1, minWidth: 0 }}>
                      <div style={{ fontWeight: 700, fontSize: 14, color: COLORS.textPrimary, marginBottom: 4, lineHeight: 1.3 }}>{p.title}</div>
                      <StatusBadge status={p.status} />
                    </div>
                    <span style={{ color: COLORS.textSecondary, fontSize: 18 }}>›</span>
                  </div>
                  <div style={{ fontSize: 12, color: COLORS.textSecondary, marginBottom: 8 }}>
                    📍 {p.department} • 📡 {p.geofence}m zone
                  </div>
                  <ProgressBar value={p.completion} />
                  <div style={{ display: "flex", justifyContent: "space-between", marginTop: 6 }}>
                    <span style={{ fontSize: 12, color: COLORS.accent, fontWeight: 600 }}>{p.completion}% done</span>
                    <span style={{ fontSize: 12, color: COLORS.textSecondary }}>₹{p.budget} Cr</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {tab === "map" && (
          <div style={{ padding: 16 }}>
            {/* Simulated map */}
            <div style={{
              background: "#E8F4F8", borderRadius: 20, height: 260, position: "relative",
              overflow: "hidden", marginBottom: 16, border: `1px solid ${COLORS.divider}`,
              display: "flex", alignItems: "center", justifyContent: "center",
            }}>
              {/* Grid lines to simulate map */}
              <svg width="100%" height="100%" style={{ position: "absolute", opacity: 0.3 }}>
                {[...Array(8)].map((_, i) => (
                  <line key={`h${i}`} x1="0" y1={i * 37} x2="100%" y2={i * 37} stroke={COLORS.accent} strokeWidth="0.5" />
                ))}
                {[...Array(12)].map((_, i) => (
                  <line key={`v${i}`} x1={i * 33} y1="0" x2={i * 33} y2="100%" stroke={COLORS.accent} strokeWidth="0.5" />
                ))}
              </svg>
              {/* Project pins */}
              {PROJECTS.map((p, i) => (
                <div key={p.id} onClick={() => setSelectedProject(p)} style={{
                  position: "absolute",
                  left: `${20 + i * 22}%`,
                  top: `${30 + (i % 2) * 28}%`,
                  cursor: "pointer",
                  display: "flex", flexDirection: "column", alignItems: "center",
                }}>
                  {/* Geofence circle */}
                  <div style={{
                    position: "absolute",
                    width: `${p.geofence / 8}px`, height: `${p.geofence / 8}px`,
                    borderRadius: "50%",
                    background: COLORS.accent + "20",
                    border: `2px solid ${COLORS.accent}50`,
                    transform: "translate(-50%, -50%)",
                    top: "50%", left: "50%",
                  }} />
                  <div style={{
                    background: STATUS_COLORS[p.status] || COLORS.accent,
                    borderRadius: "50%", width: 36, height: 36,
                    display: "flex", alignItems: "center", justifyContent: "center",
                    fontSize: 18, boxShadow: "0 4px 12px rgba(0,0,0,0.25)",
                    border: "2px solid white", zIndex: 2, position: "relative",
                  }}>
                    {p.emoji}
                  </div>
                  <div style={{
                    background: COLORS.primary, color: "#fff", fontSize: 9, fontWeight: 700,
                    padding: "2px 6px", borderRadius: 6, marginTop: 4, whiteSpace: "nowrap", zIndex: 2,
                    maxWidth: 80, overflow: "hidden", textOverflow: "ellipsis",
                  }}>
                    {p.title.split(" ").slice(0, 2).join(" ")}
                  </div>
                </div>
              ))}
              {/* User location */}
              <div style={{
                position: "absolute", left: "55%", top: "55%",
                width: 14, height: 14, borderRadius: "50%",
                background: COLORS.accent, border: "3px solid #fff",
                boxShadow: "0 0 0 6px " + COLORS.accent + "40",
              }} />
              <div style={{
                position: "absolute", bottom: 12, right: 12,
                background: "#fff", borderRadius: 8, padding: "4px 10px",
                fontSize: 11, color: COLORS.textSecondary, border: `1px solid ${COLORS.divider}`,
              }}>
                📍 Pune, MH
              </div>
            </div>

            <div style={{ fontWeight: 700, fontSize: 15, marginBottom: 12, color: COLORS.textPrimary }}>
              Tap a pin to view project details
            </div>

            {/* Simulate trigger notification */}
            <button
              onClick={() => triggerNotification(PROJECTS[0])}
              style={{
                width: "100%", padding: "12px", borderRadius: 14,
                background: COLORS.primary + "12", border: `1px dashed ${COLORS.primary}`,
                color: COLORS.primary, fontWeight: 600, fontSize: 14, cursor: "pointer",
              }}
            >
              📡 Simulate Geo-fence Trigger
            </button>
          </div>
        )}

        {tab === "alerts" && (
          <div style={{ padding: 16 }}>
            <div style={{ fontWeight: 800, fontSize: 18, marginBottom: 16 }}>Alerts & Updates</div>
            {PROJECTS.map((p, i) => (
              <div key={p.id} onClick={() => setSelectedProject(p)} style={{
                background: "#fff", borderRadius: 16, border: `1px solid ${COLORS.divider}`,
                padding: 14, marginBottom: 12, cursor: "pointer",
                display: "flex", gap: 12, alignItems: "flex-start",
              }}>
                <div style={{
                  width: 44, height: 44, borderRadius: 10, background: COLORS.primary + "15",
                  display: "flex", alignItems: "center", justifyContent: "center", fontSize: 22, flexShrink: 0,
                }}>{p.emoji}</div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontWeight: 700, fontSize: 14 }}>{p.title}</div>
                  <div style={{ fontSize: 12, color: COLORS.textSecondary, marginTop: 4, lineHeight: 1.4 }}>
                    {i === 0 ? "You are 320m from this project. " : ""}
                    {p.completion}% complete • ₹{p.budget} Cr project
                  </div>
                </div>
                <div style={{ fontSize: 10, color: COLORS.textSecondary, whiteSpace: "nowrap" }}>
                  {["2m", "1h", "3d", "1w"][i]} ago
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Bottom nav */}
      <div style={{
        background: "#fff", borderTop: `1px solid ${COLORS.divider}`,
        display: "flex", padding: "8px 0 4px",
      }}>
        {[
          { id: "feed", emoji: "🏠", label: "Feed" },
          { id: "map", emoji: "🗺️", label: "Map" },
          { id: "alerts", emoji: "🔔", label: "Alerts" },
        ].map(t => (
          <button key={t.id} onClick={() => setTab(t.id)} style={{
            flex: 1, background: "none", border: "none", cursor: "pointer",
            display: "flex", flexDirection: "column", alignItems: "center", gap: 2, padding: "4px 0",
          }}>
            <span style={{ fontSize: 22 }}>{t.emoji}</span>
            <span style={{ fontSize: 10, fontWeight: 600, color: tab === t.id ? COLORS.primary : COLORS.textSecondary }}>
              {t.label}
            </span>
            {tab === t.id && <div style={{ width: 16, height: 2, background: COLORS.primary, borderRadius: 1 }} />}
          </button>
        ))}
      </div>
    </div>
  );
}

function AdminApp() {
  const [projects, setProjects] = useState(PROJECTS);
  const [view, setView] = useState("dashboard");
  const [selectedProject, setSelectedProject] = useState(null);
  const [form, setForm] = useState({ title: "", category: "hospital", status: "Planning", budget: "", department: "", completion: 0, geofence: 500, description: "" });
  const [step, setStep] = useState(0);
  const [search, setSearch] = useState("");

  const filtered = projects.filter(p =>
    p.title.toLowerCase().includes(search.toLowerCase()) ||
    p.department.toLowerCase().includes(search.toLowerCase())
  );

  const handleAdd = () => {
    if (!form.title || !form.budget) return;
    const newP = {
      id: Date.now().toString(), emoji: "📌",
      ...form, budget: parseFloat(form.budget) || 0, spent: 0,
      lat: 18.5204, lng: 73.8567, impacts: [], updates: [],
      startDate: "2025", endDate: "2026",
      contractor: "TBD",
    };
    setProjects(p => [newP, ...p]);
    setView("dashboard");
    setForm({ title: "", category: "hospital", status: "Planning", budget: "", department: "", completion: 0, geofence: 500, description: "" });
    setStep(0);
  };

  const totalBudget = projects.reduce((s, p) => s + p.budget, 0);
  const totalSpent = projects.reduce((s, p) => s + p.spent, 0);

  if (selectedProject) {
    return (
      <div style={{ display: "flex", flexDirection: "column", height: "100%" }}>
        <ProjectDetailView project={selectedProject} onBack={() => setSelectedProject(null)} />
      </div>
    );
  }

  return (
    <div style={{ display: "flex", flexDirection: "column", height: "100%", background: COLORS.surface }}>
      {/* AppBar */}
      <div style={{ background: COLORS.primary, padding: "14px 16px" }}>
        <div style={{ color: "#fff", fontWeight: 800, fontSize: 20 }}>CivicPulse Admin</div>
        <div style={{ color: "rgba(255,255,255,0.6)", fontSize: 11 }}>Manage projects & geo-fences</div>
      </div>

      <div style={{ flex: 1, overflowY: "auto" }}>
        {view === "dashboard" && (
          <div style={{ padding: 16 }}>
            {/* Stats */}
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 10, marginBottom: 14 }}>
              {[
                { label: "Total", value: projects.length, emoji: "📁", color: COLORS.primary },
                { label: "Active", value: projects.filter(p => p.status === "Under Construction").length, emoji: "🚧", color: COLORS.warning },
                { label: "Done", value: projects.filter(p => p.status === "Completed").length, emoji: "✅", color: COLORS.success },
              ].map(s => (
                <div key={s.label} style={{
                  background: "#fff", borderRadius: 16, border: `1px solid ${COLORS.divider}`,
                  padding: 12, textAlign: "center",
                }}>
                  <div style={{ fontSize: 22 }}>{s.emoji}</div>
                  <div style={{ fontWeight: 800, fontSize: 22, color: s.color }}>{s.value}</div>
                  <div style={{ fontSize: 11, color: COLORS.textSecondary }}>{s.label}</div>
                </div>
              ))}
            </div>

            {/* Budget card */}
            <div style={{
              background: `linear-gradient(135deg, #064E3B, ${COLORS.success})`,
              borderRadius: 18, padding: 18, marginBottom: 14,
            }}>
              <div style={{ color: "rgba(255,255,255,0.7)", fontSize: 12, marginBottom: 6 }}>Budget Overview</div>
              <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 10 }}>
                <div>
                  <div style={{ color: "#fff", fontWeight: 800, fontSize: 24 }}>₹{totalBudget.toLocaleString()} Cr</div>
                  <div style={{ color: "rgba(255,255,255,0.6)", fontSize: 11 }}>Total Sanctioned</div>
                </div>
                <div style={{ textAlign: "right" }}>
                  <div style={{ color: "#fff", fontWeight: 800, fontSize: 18 }}>₹{totalSpent.toLocaleString()} Cr</div>
                  <div style={{ color: "rgba(255,255,255,0.6)", fontSize: 11 }}>Utilized</div>
                </div>
              </div>
              <div style={{ background: "rgba(255,255,255,0.2)", borderRadius: 4, height: 6, overflow: "hidden" }}>
                <div style={{ width: `${Math.round(totalSpent / totalBudget * 100)}%`, height: 6, background: "#fff", borderRadius: 4 }} />
              </div>
            </div>

            {/* Search */}
            <div style={{
              background: "#fff", borderRadius: 12, border: `1px solid ${COLORS.divider}`,
              display: "flex", alignItems: "center", gap: 8, padding: "8px 14px", marginBottom: 14,
            }}>
              <span>🔍</span>
              <input
                value={search}
                onChange={e => setSearch(e.target.value)}
                placeholder="Search projects..."
                style={{ flex: 1, border: "none", outline: "none", fontSize: 14, background: "transparent", color: COLORS.textPrimary }}
              />
            </div>

            {/* Project list */}
            <div style={{ fontWeight: 700, fontSize: 15, marginBottom: 10 }}>{filtered.length} Projects</div>
            {filtered.map(p => (
              <div key={p.id} style={{
                background: "#fff", borderRadius: 16, border: `1px solid ${COLORS.divider}`,
                padding: 14, marginBottom: 10, cursor: "pointer",
              }}
                onClick={() => setSelectedProject(p)}
              >
                <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 8 }}>
                  <span style={{ fontSize: 24 }}>{p.emoji}</span>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontWeight: 700, fontSize: 14, lineHeight: 1.3 }}>{p.title}</div>
                    <div style={{ fontSize: 11, color: COLORS.textSecondary }}>{p.department}</div>
                  </div>
                  <StatusBadge status={p.status} />
                </div>
                <ProgressBar value={p.completion} />
                <div style={{ display: "flex", gap: 8, marginTop: 8, flexWrap: "wrap" }}>
                  <span style={{ fontSize: 11, color: COLORS.textSecondary, background: COLORS.surface, padding: "2px 8px", borderRadius: 6 }}>
                    ₹{p.budget} Cr
                  </span>
                  <span style={{ fontSize: 11, color: COLORS.textSecondary, background: COLORS.surface, padding: "2px 8px", borderRadius: 6 }}>
                    📡 {p.geofence}m zone
                  </span>
                  <span style={{ fontSize: 11, color: COLORS.textSecondary, background: COLORS.surface, padding: "2px 8px", borderRadius: 6 }}>
                    {p.completion}% done
                  </span>
                </div>
              </div>
            ))}
          </div>
        )}

        {view === "add" && (
          <div style={{ padding: 16 }}>
            <div style={{ fontWeight: 800, fontSize: 18, marginBottom: 4 }}>Add New Project</div>
            <div style={{ color: COLORS.textSecondary, fontSize: 13, marginBottom: 20 }}>Step {step + 1} of 3</div>

            {/* Step indicator */}
            <div style={{ display: "flex", gap: 6, marginBottom: 24 }}>
              {["Basic Info", "Location", "Budget"].map((s, i) => (
                <div key={s} style={{
                  flex: 1, height: 4, borderRadius: 4,
                  background: i <= step ? COLORS.primary : COLORS.divider,
                  transition: "background 0.3s",
                }} />
              ))}
            </div>

            {step === 0 && (
              <div style={{ display: "flex", flexDirection: "column", gap: 14 }}>
                <div>
                  <label style={{ fontSize: 13, fontWeight: 600, color: COLORS.textSecondary, display: "block", marginBottom: 6 }}>Category</label>
                  <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
                    {[{id:"hospital",e:"🏥"},{id:"metro",e:"🚇"},{id:"water",e:"💧"},{id:"road",e:"🛣️"},{id:"college",e:"🎓"},{id:"park",e:"🌳"}].map(c => (
                      <button key={c.id} onClick={() => setForm(f => ({...f, category: c.id}))} style={{
                        padding: "10px 14px", borderRadius: 12, fontSize: 20, cursor: "pointer",
                        border: `2px solid ${form.category === c.id ? COLORS.primary : COLORS.divider}`,
                        background: form.category === c.id ? COLORS.primary + "10" : "#fff",
                      }}>{c.e}</button>
                    ))}
                  </div>
                </div>
                {[
                  { key: "title", label: "Project Title *", placeholder: "e.g. AIIMS Phase 2..." },
                  { key: "department", label: "Department", placeholder: "e.g. Ministry of Health" },
                  { key: "description", label: "Description", placeholder: "Brief description..." },
                ].map(f => (
                  <div key={f.key}>
                    <label style={{ fontSize: 13, fontWeight: 600, color: COLORS.textSecondary, display: "block", marginBottom: 6 }}>{f.label}</label>
                    <input
                      value={form[f.key]}
                      onChange={e => setForm(p => ({...p, [f.key]: e.target.value}))}
                      placeholder={f.placeholder}
                      style={{
                        width: "100%", padding: "12px 14px", borderRadius: 12, fontSize: 14,
                        border: `1px solid ${COLORS.divider}`, outline: "none",
                        background: COLORS.surface, boxSizing: "border-box", color: COLORS.textPrimary,
                      }}
                    />
                  </div>
                ))}
                <div>
                  <label style={{ fontSize: 13, fontWeight: 600, color: COLORS.textSecondary, display: "block", marginBottom: 6 }}>Status</label>
                  <select value={form.status} onChange={e => setForm(f => ({...f, status: e.target.value}))}
                    style={{ width: "100%", padding: "12px 14px", borderRadius: 12, fontSize: 14, border: `1px solid ${COLORS.divider}`, background: COLORS.surface, color: COLORS.textPrimary }}>
                    {["Planning","Approved","Under Construction","Completed","Paused"].map(s => <option key={s}>{s}</option>)}
                  </select>
                </div>
              </div>
            )}

            {step === 1 && (
              <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>
                {/* Map simulation */}
                <div style={{
                  background: "#E8F4F8", borderRadius: 16, height: 200, position: "relative",
                  border: `1px solid ${COLORS.divider}`, display: "flex", alignItems: "center", justifyContent: "center",
                  overflow: "hidden",
                }}>
                  <svg width="100%" height="100%" style={{ position: "absolute", opacity: 0.3 }}>
                    {[...Array(6)].map((_, i) => <line key={i} x1="0" y1={i * 40} x2="100%" y2={i * 40} stroke={COLORS.accent} strokeWidth="0.5" />)}
                    {[...Array(10)].map((_, i) => <line key={i} x1={i * 36} y1="0" x2={i * 36} y2="100%" stroke={COLORS.accent} strokeWidth="0.5" />)}
                  </svg>
                  {/* Geofence preview */}
                  <div style={{
                    width: form.geofence / 4, height: form.geofence / 4,
                    borderRadius: "50%", background: COLORS.accent + "20",
                    border: `2px solid ${COLORS.accent}`,
                    display: "flex", alignItems: "center", justifyContent: "center",
                    transition: "all 0.3s",
                  }}>
                    <div style={{ width: 20, height: 20, borderRadius: "50%", background: COLORS.primary }} />
                  </div>
                  <div style={{ position: "absolute", bottom: 8, right: 8, background: "#fff", borderRadius: 8, padding: "4px 10px", fontSize: 11, color: COLORS.textSecondary }}>
                    Tap to set location
                  </div>
                </div>
                <div>
                  <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 8 }}>
                    <label style={{ fontSize: 13, fontWeight: 600, color: COLORS.textSecondary }}>Geo-fence Radius</label>
                    <span style={{ fontWeight: 700, color: COLORS.accent }}>{form.geofence}m</span>
                  </div>
                  <input type="range" min="100" max="2000" step="100" value={form.geofence}
                    onChange={e => setForm(f => ({...f, geofence: parseInt(e.target.value)}))}
                    style={{ width: "100%", accentColor: COLORS.primary }} />
                  <div style={{ display: "flex", justifyContent: "space-between", fontSize: 11, color: COLORS.textSecondary }}>
                    <span>100m</span><span>2000m</span>
                  </div>
                </div>
                <div style={{ background: COLORS.primary + "10", borderRadius: 12, padding: 12, fontSize: 12, color: COLORS.primary }}>
                  📡 Citizens within <strong>{form.geofence}m</strong> of this location will receive automatic notifications about this project.
                </div>
              </div>
            )}

            {step === 2 && (
              <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>
                <div>
                  <label style={{ fontSize: 13, fontWeight: 600, color: COLORS.textSecondary, display: "block", marginBottom: 6 }}>Budget (₹ Crore) *</label>
                  <input
                    type="number" value={form.budget}
                    onChange={e => setForm(f => ({...f, budget: e.target.value}))}
                    placeholder="e.g. 4200"
                    style={{ width: "100%", padding: "12px 14px", borderRadius: 12, fontSize: 14, border: `1px solid ${COLORS.divider}`, background: COLORS.surface, boxSizing: "border-box", color: COLORS.textPrimary, outline: "none" }}
                  />
                </div>
                <div>
                  <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 8 }}>
                    <label style={{ fontSize: 13, fontWeight: 600, color: COLORS.textSecondary }}>Completion %</label>
                    <span style={{ fontWeight: 700, color: COLORS.success }}>{form.completion}%</span>
                  </div>
                  <input type="range" min="0" max="100" step="5" value={form.completion}
                    onChange={e => setForm(f => ({...f, completion: parseInt(e.target.value)}))}
                    style={{ width: "100%", accentColor: COLORS.success }} />
                  <ProgressBar value={form.completion} color={COLORS.success} />
                </div>
              </div>
            )}

            <div style={{ display: "flex", gap: 10, marginTop: 24 }}>
              {step > 0 && (
                <button onClick={() => setStep(s => s - 1)} style={{
                  flex: 1, padding: "13px", borderRadius: 14, border: `1px solid ${COLORS.divider}`,
                  background: "#fff", fontSize: 15, fontWeight: 600, cursor: "pointer", color: COLORS.textPrimary,
                }}>
                  Back
                </button>
              )}
              <button onClick={() => step < 2 ? setStep(s => s + 1) : handleAdd()} style={{
                flex: 2, padding: "13px", borderRadius: 14, border: "none",
                background: COLORS.primary, color: "#fff", fontSize: 15, fontWeight: 700, cursor: "pointer",
              }}>
                {step === 2 ? "✅ Save Project" : "Next →"}
              </button>
            </div>
          </div>
        )}
      </div>

      {/* Bottom bar */}
      <div style={{ background: "#fff", borderTop: `1px solid ${COLORS.divider}`, padding: "10px 16px" }}>
        <button onClick={() => setView(v => v === "dashboard" ? "add" : "dashboard")} style={{
          width: "100%", padding: "14px", borderRadius: 14, border: "none",
          background: view === "add" ? COLORS.divider : COLORS.primary,
          color: view === "add" ? COLORS.textSecondary : "#fff",
          fontSize: 15, fontWeight: 700, cursor: "pointer",
          display: "flex", alignItems: "center", justifyContent: "center", gap: 8,
        }}>
          {view === "add" ? "← Back to Dashboard" : "+ Add New Project"}
        </button>
      </div>
    </div>
  );
}

export default function CivicPulsePrototype() {
  const [role, setRole] = useState(null);

  if (role === "citizen") return (
    <div style={{ maxWidth: 390, margin: "0 auto", height: "100vh", display: "flex", flexDirection: "column", fontFamily: "'Segoe UI', system-ui, sans-serif", background: "#fff", boxShadow: "0 0 60px rgba(0,0,0,0.15)" }}>
      <CitizenApp />
    </div>
  );

  if (role === "admin") return (
    <div style={{ maxWidth: 390, margin: "0 auto", height: "100vh", display: "flex", flexDirection: "column", fontFamily: "'Segoe UI', system-ui, sans-serif", background: "#fff", boxShadow: "0 0 60px rgba(0,0,0,0.15)" }}>
      <AdminApp />
    </div>
  );

  return (
    <div style={{
      maxWidth: 390, margin: "0 auto", height: "100vh",
      display: "flex", flexDirection: "column",
      background: `linear-gradient(170deg, ${COLORS.primary} 0%, #1E3A8A 60%, #0F2654 100%)`,
      fontFamily: "'Segoe UI', system-ui, sans-serif",
      boxShadow: "0 0 60px rgba(0,0,0,0.2)",
      alignItems: "center", justifyContent: "center", padding: 32, boxSizing: "border-box",
    }}>
      {/* Logo */}
      <div style={{
        width: 100, height: 100, borderRadius: "50%",
        background: "rgba(255,255,255,0.12)",
        display: "flex", alignItems: "center", justifyContent: "center",
        marginBottom: 28, fontSize: 52,
        border: "2px solid rgba(255,255,255,0.2)",
      }}>
        🏛️
      </div>

      <div style={{ color: "#fff", fontSize: 38, fontWeight: 900, letterSpacing: -1, marginBottom: 6 }}>CivicPulse</div>
      <div style={{ color: "rgba(255,255,255,0.55)", fontSize: 15, marginBottom: 60, textAlign: "center" }}>
        Your Government. Your Progress.
      </div>

      <div style={{ width: "100%", display: "flex", flexDirection: "column", gap: 16 }}>
        <button onClick={() => setRole("citizen")} style={{
          background: "#fff", border: "none", borderRadius: 20, padding: "20px 24px", cursor: "pointer",
          display: "flex", alignItems: "center", gap: 16, width: "100%", textAlign: "left",
          boxShadow: "0 8px 32px rgba(0,0,0,0.2)",
        }}>
          <span style={{ fontSize: 32, width: 44, textAlign: "center" }}>👤</span>
          <div>
            <div style={{ fontWeight: 700, fontSize: 17, color: COLORS.primary }}>I'm a Citizen</div>
            <div style={{ fontSize: 13, color: COLORS.textSecondary }}>Explore projects near me</div>
          </div>
          <span style={{ marginLeft: "auto", color: COLORS.primary, fontSize: 20 }}>›</span>
        </button>

        <button onClick={() => setRole("admin")} style={{
          background: "transparent", border: "2px solid rgba(255,255,255,0.4)", borderRadius: 20,
          padding: "20px 24px", cursor: "pointer", display: "flex", alignItems: "center", gap: 16,
          width: "100%", textAlign: "left",
        }}>
          <span style={{ fontSize: 32, width: 44, textAlign: "center" }}>🏛️</span>
          <div>
            <div style={{ fontWeight: 700, fontSize: 17, color: "#fff" }}>Government Official</div>
            <div style={{ fontSize: 13, color: "rgba(255,255,255,0.6)" }}>Manage projects & geo-fences</div>
          </div>
          <span style={{ marginLeft: "auto", color: "rgba(255,255,255,0.6)", fontSize: 20 }}>›</span>
        </button>
      </div>

      <div style={{ color: "rgba(255,255,255,0.3)", fontSize: 11, marginTop: 48, textAlign: "center" }}>
        Powered by PMIS • Govt. of India Initiative
      </div>
    </div>
  );
}
