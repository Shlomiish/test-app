import { useState } from 'react';

//const API_BASE = 'http://localhost:8080'; // עובד כי אתה ניגש מהדפדפן של המחשב שלך

const API_BASE = '';

function pretty(obj) {
  return JSON.stringify(obj, null, 2);
}

export default function App() {
  const [loading, setLoading] = useState(false);
  const [events, setEvents] = useState([]);

  async function callApi(path, label) {
    setLoading(true);
    try {
      const res = await fetch(`${API_BASE}${path}`);
      const json = await res.json();

      setEvents((prev) => [
        {
          id: `${Date.now()}-${Math.random().toString(36).slice(2)}`,
          label,
          at: new Date().toLocaleString(),
          json,
        },
        ...prev,
      ]);
    } catch (e) {
      setEvents((prev) => [
        {
          id: `${Date.now()}-${Math.random().toString(36).slice(2)}`,
          label: 'Error',
          at: new Date().toLocaleString(),
          json: { ok: false, error: String(e) },
        },
        ...prev,
      ]);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className='page'>
      <header className='header'>
        <h1>Kafka Button Demo</h1>
        <p>Click a button → fetch JSON → render UI → Kafka event produced.</p>
      </header>

      <div className='buttons'>
        <button
          className='btn primary'
          disabled={loading}
          onClick={() => callApi('/api/button1', 'Button 1')}
        >
          Button 1
        </button>

        <button
          className='btn secondary'
          disabled={loading}
          onClick={() => callApi('/api/button2', 'Button 2')}
        >
          Button 2
        </button>
      </div>

      <section className='panel'>
        <div className='panelHeader'>
          <h2>Responses</h2>
          <span className={loading ? 'badge on' : 'badge'}>{loading ? 'Loading...' : 'Idle'}</span>
        </div>

        {events.length === 0 ? (
          <div className='empty'>No responses yet. Click a button.</div>
        ) : (
          <div className='cards'>
            {events.map((e) => (
              <div className='card' key={e.id}>
                <div className='cardTop'>
                  <div className='title'>{e.label}</div>
                  <div className='time'>{e.at}</div>
                </div>
                <pre className='code'>{pretty(e.json)}</pre>
              </div>
            ))}
          </div>
        )}
      </section>
    </div>
  );
}
